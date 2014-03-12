//
//  MCCFloorViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorViewController.h"
#import "MCCEvent.h"
#import "MCCClient.h"
#import "MCCNavPath.h"
#import "MCCNavData.h"
#import "MCCFloorPlanEdge.h"
#import "MCCFloorPlanImage.h"
#import "MCCFloorPlanImageLocation.h"
#import "MCCFloorPlanImageMapping.h"
#import "MCCFloorPlanLocation.h"
#import <MBXMapKit/MBXMapKit.h>

@interface MCCFloorViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MCCFloorPlanImage *floor1;
@property (strong, nonatomic) MCCFloorPlanImageLocation *floor1TopLeft;

@property (strong, nonatomic) MKPolyline *polyline;

@end

@implementation MCCFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
//    self.mapView.mapID = @"musiccitycenter.du2z9f6r";
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(36.1575, -86.777), MKCoordinateSpanMake(.004, .004));

    self.mapView.delegate = self;
    
//    self.mapView.mapType = MKMapTypeHybrid

    
    self.floor1TopLeft = [MCCFloorPlanImageLocation floorPlanImageLocationWithX:240
                                                                           andY:3196];
    self.floor1 = [MCCFloorPlanImage floorPlanImageWithSizeX:916
                                                       sizeY:628
                                                     topLeft:CLLocationCoordinate2DMake(36.158468, -86.777133)
                                                    topRight:CLLocationCoordinate2DMake(36.156458, -86.775824)
                                               andBottomLeft:CLLocationCoordinate2DMake(36.157835, -86.778613)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPolylineFromEvent:(MCCEvent *)event {
    NSLog(@"Generating polyline");
    
    MCCClient *client = [MCCClient sharedClient];
    
    [client fetchFloorPlan:@"full-test-1"
       withCompletionBlock:^(MCCNavData *navData) {
    
        [client shortestPathOnFloorPlan:@"full-test-1"
                                   from:@"110"
                                     to:event.locationId
                    withCompletionBlock:^(MCCNavPath *path) {
            
            // Get the number of points, which is the number of edges + 1
            NSUInteger numPoints = [path.edges count] + 1;
            
            // Allocate the array of coordinates
            CLLocationCoordinate2D coords[numPoints];
            
            // Start with the start of the first edge
            MCCFloorPlanEdge *edge0 = [path.edges firstObject];
            NSLog(@"%@",edge0.startLocation.locationId);
            MCCFloorPlanImageLocation *location0 = [navData.mapping coordinatesOfLocation:edge0.startLocation.locationId];
            
            MCCFloorPlanImageLocation *translatedLocation0 =
            [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location0.x - self.floor1TopLeft.x
                                                              andY:location0.y - self.floor1TopLeft.y];
            
            
            // Turn the floorplan location into lat-long
            coords[0] = [self.floor1 coordinateFromFloorPlanImageLocation:translatedLocation0];
            
            int i = 1;
            
            // Then do the end of all the other edges
            for (MCCFloorPlanEdge *edge in path.edges) {
                MCCFloorPlanImageLocation *location = [navData.mapping coordinatesOfLocation:edge.endLocation.locationId];
                
                NSLog(@"%@",edge.endLocation.locationId);
                
                MCCFloorPlanImageLocation *translatedLocation =
                [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location.x - self.floor1TopLeft.x
                                                                  andY:location.y - self.floor1TopLeft.y];
                
                // Turn the floorplan location into lat-long
                coords[i] = [self.floor1 coordinateFromFloorPlanImageLocation:translatedLocation];
                ++i;
            }
            
            self.polyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
            
            
            [self.mapView addOverlay:self.polyline];
            [self.mapView setNeedsDisplay];
        }];
    }];
}


#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.fillColor = [UIColor redColor];
        routeRenderer.strokeColor = [UIColor redColor];
        routeRenderer.lineWidth = 4;
        return routeRenderer;
    } else {
        return nil;
    }
}

@end

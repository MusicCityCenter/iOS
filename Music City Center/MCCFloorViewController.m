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
#import "MCCFloorPlanEdge.h"
#import "MCCFloorPlanImage.h"
#import "MCCFloorPlanImageLocation.h"
#import "MCCFloorPlanImageMapping.h"
#import "MCCFloorPlanLocation.h"
#import <MBXMapKit/MBXMapKit.h>

@interface MCCFloorViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MCCFloorPlanImage *floor1;
@property (strong, nonatomic) MCCFloorPlanImageLocation *floor1TopLeft;

@end

@implementation MCCFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
//    self.mapView.mapID = @"musiccitycenter.du2z9f6r";
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(36.1575, -86.777), MKCoordinateSpanMake(.004, .004));
    
    self.floor1TopLeft = [MCCFloorPlanImageLocation floorPlanImageLocationWithX:240 andY:3196];
    self.floor1 = [MCCFloorPlanImage
                   floorPlanImageWithSizeX:916
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
    
    [client shortestPathOnFloorPlan:@"full-test-1" from:@"B-1-2" to:event.locationId withCompletionBlock:^(MCCNavPath *path) {
        
        // Get an image mapping
        MCCFloorPlanImageMapping *mapping = [MCCFloorPlanImageMapping floorPlanImageMappingWithImageURL:[NSURL URLWithString:@"/mcc/image/floorplan/full-test-1"]];
        
        // Get the number of points, which is the number of edges + 1
        NSUInteger numPoints = [path.edges count] + 1;
        
        // Allocate the array of coordinates
        CLLocationCoordinate2D *coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
        
        // Start with the start of the first edge
        MCCFloorPlanEdge *edge0 = [path.edges firstObject];
        MCCFloorPlanImageLocation *location0 = [mapping coordinatesOfLocation:edge0.startLocation.locationId];
        
        MCCFloorPlanImageLocation *translatedLocation0 =
        [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location0.x - self.floor1TopLeft.x
                                                          andY:location0.y - self.floor1TopLeft.y];
        
        // Turn the floorplan location into lat-long
        coords[0] = [self.floor1 coordinateFromFloorPlanImageLocation:translatedLocation0];
        
        int i = 1;
        
        // Then do the end of all the other edges
        for (MCCFloorPlanEdge *edge in path.edges) {
            MCCFloorPlanImageLocation *location = [mapping coordinatesOfLocation:edge.endLocation.locationId];
            
            MCCFloorPlanImageLocation *translatedLocation =
            [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location.x - self.floor1TopLeft.x
                                                              andY:location.y - self.floor1TopLeft.y];
            
            // Turn the floorplan location into lat-long
            coords[i] = [self.floor1 coordinateFromFloorPlanImageLocation:translatedLocation];
            ++i;
        }
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:numPoints];
        
        [self.mapView addOverlay:polyline];
        [self.mapView setNeedsDisplay];
    }];
}

@end

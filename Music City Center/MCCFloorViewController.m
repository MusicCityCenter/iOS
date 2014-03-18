//
//  MCCFloorViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCAppDelegate.h"
#import "MCCFloorViewController.h"
#import "MCCEvent.h"
#import "MCCClient.h"
#import "MCCNavPath.h"
#import "MCCNavData.h"
#import "MCCFloorPlan.h"
#import "MCCFloorPlanEdge.h"
#import "MCCFloorPlanImage.h"
#import "MCCFloorPlanImageLocation.h"
#import "MCCFloorPlanImageMapping.h"
#import "MCCFloorPlanLocation.h"
#import <MBXMapKit/MBXMapKit.h>


static NSString * const floorPlanId = @"full-test-1";


@interface MCCFloorViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MBXMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentDirectionButton;

@property (nonatomic, getter = isRouting) BOOL routing;

@property (strong, nonatomic) NSString *currentFloor;

@property (strong, nonatomic) MCCFloorPlanImage *floorPlanImage;
@property (strong, atomic) MCCFloorPlanImageLocation *topLeft;
@property (strong, atomic) MCCFloorPlanImageLocation *bottomRight;

@property (strong, nonatomic) MCCFloorPlanLocation *endLocation;
@property (strong, nonatomic) NSDictionary *locationData;

@property (strong, nonatomic) MKPolyline *polyline;

@property (strong, nonatomic) NSDictionary *mapIDs;

@end

@implementation MCCFloorViewController

# pragma mark - Custom Getters

-(NSDictionary *)mapIDs {
    if (!_mapIDs) {
        _mapIDs = @{@"1" : @"musiccitycenter.i1i5h4m1",
                   @"1M": @"",
                   @"2" : @"",
                   @"3" : @"",
                   @"4" : @""};
    }
    
    return _mapIDs;
}

- (void)setCurrentFloor:(NSString *)currentFloor {
    _currentFloor = currentFloor;
    
    MCCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    

    self.topLeft = [appDelegate.navData.mapping coordinatesOfLocation:[NSString stringWithFormat:@"%@-TL", _currentFloor]];
    self.bottomRight = [appDelegate.navData.mapping coordinatesOfLocation:[NSString stringWithFormat:@"%@-BR", _currentFloor]];
    
    NSInteger sizeX = self.bottomRight.x - self.topLeft.x;
    NSInteger sizeY = self.bottomRight.y - self.topLeft.y;
    
    self.floorPlanImage = [MCCFloorPlanImage floorPlanImageWithSizeX:sizeX
                                                               sizeY:sizeY
                                                             topLeft:CLLocationCoordinate2DMake(36.158468, -86.777133)
                                                            topRight:CLLocationCoordinate2DMake(36.156458, -86.775824)
                                                       andBottomLeft:CLLocationCoordinate2DMake(36.157835, -86.778613)];

}



#pragma mark - Custom Setter

- (void)setRouting:(BOOL)routing {
    _routing = routing;
    self.currentDirectionButton.hidden = !routing;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentFloor = @"1";
    
    self.mapView.mapID = self.mapIDs[self.currentFloor];
    
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(36.1575, -86.777), MKCoordinateSpanMake(.004, .004));

    self.mapView.delegate = self;
    
    self.routing = NO;
    
//    self.mapView.mapType = MKMapTypeHybrid
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPolylineToFloorPlanLocation:(MCCFloorPlanLocation *)location andLocationData:(NSDictionary *)locationData {
    
    // Save the incoming data
    self.endLocation = location;
    

    [[MCCClient sharedClient] locationFromiBeacons:locationData
                                         forFloorPlan:floorPlanId
                               withCompletionBlock:^(MCCFloorPlanLocation *floorPlanLocation) {
                                   [self drawPolylineFromStartLocation:floorPlanLocation];
                               }];
}


-(void)setPolylineToFloorPlanLocation:(MCCFloorPlanLocation *)endLocation fromFloorPlanLocation:(MCCFloorPlanLocation *)startLocation {
    self.endLocation = endLocation;
    
    [self drawPolylineFromStartLocation:startLocation];
}



#pragma mark - Map View Delegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.fillColor = [UIColor blueColor];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 4;
        renderer = routeRenderer;
    }
    
    return renderer;
}


#pragma mark - Helper Methods

-(void)drawPolylineFromStartLocation:(MCCFloorPlanLocation *)startLocation {
    NSLog(@"Generating polyline");
    
    MCCClient *client = [MCCClient sharedClient];
    
    [client fetchFloorPlan:floorPlanId
       withCompletionBlock:^(MCCNavData *navData) {
           
           [client shortestPathOnFloorPlan:floorPlanId
                                      from:startLocation.locationId
                                        to:self.endLocation.locationId
                       withCompletionBlock:^(MCCNavPath *path) {
                           
                           // Get the number of points, which is the number of edges + 1
                           NSUInteger numPoints = [path.edges count] + 1;
                           
                           // Allocate the array of coordinates
                           CLLocationCoordinate2D coords[numPoints];
                           
                           // Start with the start of the first edge
                           MCCFloorPlanEdge *firstEdge = [path.edges firstObject];
                           NSLog(@"Starting at: %@",firstEdge.startLocation.locationId);
                           NSLog(@"Ending at: %@", self.endLocation.locationId);
                           MCCFloorPlanImageLocation *firstLocation = [navData.mapping coordinatesOfLocation:firstEdge.startLocation.locationId];
                           
                           MCCFloorPlanImageLocation *firstTranslatedLocation =
                           [MCCFloorPlanImageLocation floorPlanImageLocationWithX:firstLocation.x - self.topLeft.x
                                                                             andY:firstLocation.y - self.topLeft.y];
                           
                           
                           // Turn the floorplan location into lat-long
                           coords[0] = [self.floorPlanImage coordinateFromFloorPlanImageLocation:firstTranslatedLocation];
                           
                           int i = 1;
                           
                           // Then do the end of all the other edges
                           for (MCCFloorPlanEdge *edge in path.edges) {
                               MCCFloorPlanImageLocation *location = [navData.mapping coordinatesOfLocation:edge.endLocation.locationId];
                               
                               if (location.x >= self.topLeft.x &&
                                   location.y >= self.topLeft.y &&
                                   location.x <= self.bottomRight.x &&
                                   location.y <= self.bottomRight.y) {
                                   
                                   
                                   MCCFloorPlanImageLocation *translatedLocation =
                                   [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location.x - self.topLeft.x
                                                                                     andY:location.y - self.topLeft.y];
                               
                                   // Turn the floorplan location into lat-long
                                   coords[i] = [self.floorPlanImage coordinateFromFloorPlanImageLocation:translatedLocation];
                                   ++i;
                               } else {
                                   break;
                               }
                           }
                           
                           numPoints = i;
                           
                           self.polyline = [MKPolyline polylineWithCoordinates:coords
                                                                         count:numPoints];
                           
                           
                           [self.mapView addOverlay:self.polyline];
                           
                           self.routing = YES;
                       }];
       }];

}



@end

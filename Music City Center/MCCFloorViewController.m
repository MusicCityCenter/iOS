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
#import "MCCDirectionsTableViewController.h"
#import "MCCArtAnnotation.h"


static NSString * const floorPlanId = @"full-test-1";


@interface MCCFloorViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MBXMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *currentDirectionButton;

@property (strong, nonatomic) UIBarButtonItem *endButton;

@property (strong, nonatomic) MCCNavData *navData;

@property (nonatomic, getter = isRouting) BOOL routing;
@property (nonatomic, copy) NSArray *directions;

@property (strong, nonatomic) NSString *currentFloor;

@property (strong, nonatomic) MCCFloorPlanImage *floorPlanImage;
@property (strong, atomic) MCCFloorPlanImageLocation *topLeft;
@property (strong, atomic) MCCFloorPlanImageLocation *bottomRight;

@property (strong, nonatomic) MCCFloorPlanLocation *endLocation;
@property (strong, nonatomic) NSDictionary *locationData;

@property (strong, nonatomic) MKPolyline *routePolyline;

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



#pragma mark - Custom Getter

- (UIBarButtonItem *)endButton {
    if (!_endButton) {
        _endButton = [[UIBarButtonItem alloc] initWithTitle:@"End"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(endTapped:)];
    }
    
    return _endButton;
}

#pragma mark - Custom Setter

- (void)setRouting:(BOOL)routing {
    _routing = routing;
    self.currentDirectionButton.hidden = !routing;
    
    if (routing) {
        // TODO - The user sees this change from "Button" to the first direction's
        // text. While we could just have the button start with no text, it would
        // be nice to animate the button down from the navbar (like in Maps.app)
        // once the text has been set.
        [self.currentDirectionButton setTitle:[self.directions firstObject]
                                     forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = self.endButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        [self.mapView removeOverlay:self.routePolyline];
        self.routePolyline = nil;
        self.directions = nil;
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentFloor = @"1";
    
    self.mapView.mapID = self.mapIDs[self.currentFloor];
    

    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(36.1575, -86.777), MKCoordinateSpanMake(.004, .004));
    self.mapView.delegate = self;
    
    // Hard code some art markers
    [self.mapView addAnnotation:[MCCArtAnnotation artAnnotationWithTitle:@"Guitar Picture"
                                                              coordinate:CLLocationCoordinate2DMake(36.1585, -86.777)
                                                                andImage:[UIImage imageNamed:@"guitar.jpg"]]];
    [self.mapView addAnnotation:[MCCArtAnnotation artAnnotationWithTitle:@"Music Picture"
                                                              coordinate:CLLocationCoordinate2DMake(36.1575, -86.777)
                                                                andImage:[UIImage imageNamed:@"music.jpg"]]];
    [self.mapView addAnnotation:[MCCArtAnnotation artAnnotationWithTitle:@"Trumpet Picture"
                                                              coordinate:CLLocationCoordinate2DMake(36.1580, -86.777)
                                                                andImage:[UIImage imageNamed:@"trumpet.jpg"]]];
    
    // TODO - Look into fetching these in parallel with the tile imagery by
    // modifying MBXMapKit.m.
    // See: https://github.com/mapbox/mbxmapkit/issues/75#issuecomment-37945403
    [[MCCClient sharedClient] fetchFloorPlan:@"full-test-1"
                         withCompletionBlock:^(MCCNavData *navData) {
                             self.navData = navData;
                             
                             // Fencepost
                             MCCFloorPlanEdge *firstEdge = [self.navData.floorPlan.edges firstObject];
                             [self.mapView addAnnotation:[self pointAnnotationForEdge:firstEdge
                                                                         withLocation:firstEdge.startLocation]];
                             
                             for (MCCFloorPlanEdge *edge in self.navData.floorPlan.edges) {
                                 [self.mapView addAnnotation:[self pointAnnotationForEdge:edge
                                                                             withLocation:edge.endLocation]];
                             }
                        
                         }];
    
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
                           MCCFloorPlanEdge *currentEdge = [path.edges firstObject];

                           NSLog(@"Starting at: %@",currentEdge.startLocation.locationId);
                           NSLog(@"Ending at: %@", self.endLocation.locationId);

                           MCCFloorPlanImageLocation *firstLocation = [navData.mapping coordinatesOfLocation:currentEdge.startLocation.locationId];
                           
                           MCCFloorPlanImageLocation *firstTranslatedLocation =
                           [MCCFloorPlanImageLocation floorPlanImageLocationWithX:firstLocation.x - self.topLeft.x
                                                                             andY:firstLocation.y - self.topLeft.y];
                           
                           
                           // Turn the floorplan location into lat-long
                           coords[0] = [self.floorPlanImage coordinateFromFloorPlanImageLocation:firstTranslatedLocation];

                           NSInteger i = 1;
                           NSMutableArray *directions = [NSMutableArray arrayWithCapacity:[path.edges count]];
                           
                           
                           NSString *previousDirection;
                           
                           // Then do the end of all the other edges
                           for (MCCFloorPlanEdge *edge in path.edges) {
                               MCCFloorPlanImageLocation *location = [navData.mapping coordinatesOfLocation:edge.endLocation.locationId];
                               
                               if (location.x >= self.topLeft.x &&
                                   location.y >= self.topLeft.y &&
                                   location.x <= self.bottomRight.x &&
                                   location.y <= self.bottomRight.y) {
                                   
                                   
                                   coords[i] = [self coordinateFromEdge:edge
                                                     withFloorPlanImage:self.floorPlanImage
                                                andTopLeftImageLocation:self.topLeft];
                                   ++i;
                                   
                                   // Make sure that if a user is passing through several straight edges that
                                   // the directions don't say "Go straight" repeatedly
                                   NSString *currentDirection = [self directionFromPreviousEdge:currentEdge
                                                                                     toNextEdge:edge];
                                   
                                   if (![previousDirection isEqualToString:@"Go straight"] || ![currentDirection isEqualToString:@"Go straight"]) {
                                       [directions addObject:currentDirection];
                                       
                                       previousDirection = currentDirection;
                                   }
                                   
                                   currentEdge = edge;
                                 
                               } else {
                                   break;
                               }
                           }
                           
                           numPoints = i;
                           
                    
                           self.routePolyline = [MKPolyline polylineWithCoordinates:coords
                                                                              count:numPoints];
                           
                           [self.mapView addOverlay:self.routePolyline];
                           
                           self.directions = [directions copy];
                           self.routing = YES;
                       }];
       }];

}
    
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentDirections"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        MCCDirectionsTableViewController *directionsTableViewController = (MCCDirectionsTableViewController *)navigationController.visibleViewController;
        
        directionsTableViewController.directions = self.directions;
    }
}

#pragma mark - Helper Methods

- (NSString *)directionFromPreviousEdge:(MCCFloorPlanEdge *)previousEdge toNextEdge:(MCCFloorPlanEdge *)nextEdge {
    NSString *direction;
    
    CGFloat relativeAngle = nextEdge.angle - previousEdge.angle;
    
    if (relativeAngle > 45) {
        direction = @"Turn left";
    } else if (relativeAngle < -45) {
        direction = @"Turn right";
    } else {
        direction = @"Go straight";
    }
    
    return direction;
}


- (CLLocationCoordinate2D)coordinateFromEdge:(MCCFloorPlanEdge *)edge withFloorPlanImage:(MCCFloorPlanImage *)floorPlanImage andTopLeftImageLocation:(MCCFloorPlanImageLocation *)topLeftImageLocation {
    MCCFloorPlanImageLocation *location = [self.navData.mapping coordinatesOfLocation:edge.endLocation.locationId];
    
    MCCFloorPlanImageLocation *translatedLocation = [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location.x - topLeftImageLocation.x
                                                                                                      andY:location.y - topLeftImageLocation.y];
    
    // Turn the floorplan location into lat/long
    return [floorPlanImage coordinateFromFloorPlanImageLocation:translatedLocation];
}

- (MKPointAnnotation *)pointAnnotationForEdge:(MCCFloorPlanEdge *)edge withLocation:(MCCFloorPlanLocation *)location {
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    // TODO - Don't hardcore this floor and top left
    pointAnnotation.coordinate = [self coordinateFromEdge:edge
                                       withFloorPlanImage:self.floorPlanImage
                                  andTopLeftImageLocation:self.topLeft];
    pointAnnotation.title = location.locationId;
    
    return pointAnnotation;
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString * const pointAnnotationIdentifier = @"PointAnnotation";
    static NSString * const artAnnotationIdentifier = @"ArtAnnotation";
    
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:pointAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointAnnotationIdentifier];
        }
    } else if ([annotation isKindOfClass:[MCCArtAnnotation class]]) {
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:artAnnotationIdentifier];
        
        if (!pinAnnotationView) {
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:artAnnotationIdentifier];
        }
        
        pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46.0, 46.0)];
        pinAnnotationView.leftCalloutAccessoryView = imageView;
        
        UIButton *detailDisclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotationView.rightCalloutAccessoryView = detailDisclosureButton;
        
        annotationView = pinAnnotationView;
    }
    
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    // TODO - Eventually asyncronously fetch the image for the annotation view from the
    //server.
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        MCCArtAnnotation *artAnnotation = (MCCArtAnnotation *)view.annotation;
        
        imageView.image = artAnnotation.image;
    }
}

#pragma mark - IB Actions

- (IBAction)endTapped:(UIBarButtonItem *)sender {
    self.routing = NO;
}

// Unwind segue
- (IBAction)directionsDone:(UIStoryboardSegue *)segue {}

@end

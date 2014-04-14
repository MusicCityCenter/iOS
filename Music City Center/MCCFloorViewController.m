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
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface MCCFloorViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MBXMapView *mapView;

@property (strong, nonatomic) MCCFloorPlanImage *floor1;
@property (strong, nonatomic) MCCFloorPlanImageLocation *floor1TopLeft;
@property (strong, nonatomic) MCCFloorPlanLocation *endLocation;

@property (strong, nonatomic) MKPolyline *polyline;

// Beacons
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *beacons;

@end

@implementation MCCFloorViewController


# pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.mapID = @"musiccitycenter.vqloko6r";
    
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

- (void)setPolylineFromFloorPlanLocation:(MCCFloorPlanLocation *)location andBeacons:(NSArray *)beacons {
    
    // Save the incoming data
    self.endLocation = location;
    self.beacons = beacons;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Get the current location, then wait for the callback to send data to the server
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - MKMapViewDelegate

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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"LOCATION DATA RECEIVED");
    
    [self.locationManager stopUpdatingLocation];
    
    NSMutableArray *beaconData = [NSMutableArray array];
    for (CLBeacon *beacon in self.beacons) {
        NSMutableDictionary *thisBeacon = [NSMutableDictionary dictionary];
        thisBeacon[@"uuid"] = beacon.proximityUUID.UUIDString;
        thisBeacon[@"major"] = beacon.major;
        thisBeacon[@"minor"] = beacon.minor;
        thisBeacon[@"rssi"] = [NSNumber numberWithLong:beacon.rssi];
        thisBeacon[@"accuracy"] = [NSNumber numberWithDouble:beacon.accuracy];
        if (beacon.proximity == CLProximityUnknown) {
            thisBeacon[@"distance"] = @"Unknown Proximity";
        } else if (beacon.proximity == CLProximityImmediate) {
            thisBeacon[@"distance"] = @"Immediate";
        } else if (beacon.proximity == CLProximityNear) {
            thisBeacon[@"distance"] = @"Near";
        } else if (beacon.proximity == CLProximityFar) {
            thisBeacon[@"distance"] = @"Far";
        }
        [beaconData addObject:thisBeacon];
    }
    
    NSMutableDictionary *locationData = [NSMutableDictionary dictionary];
    
    locationData[@"beaconData"] = beaconData;
    
    CLLocation *curLocation = [locations lastObject];
    
    NSMutableDictionary *curLocData = [NSMutableDictionary dictionary];
    curLocData[@"latitude"] = [NSNumber numberWithDouble:curLocation.coordinate.latitude];
    curLocData[@"longitude"] = [NSNumber numberWithDouble:curLocation.coordinate.longitude];
    curLocData[@"altitude"] = [NSNumber numberWithDouble:curLocation.altitude];
    curLocData[@"horizontalAccuracy"] = [NSNumber numberWithDouble:curLocation.horizontalAccuracy];
    curLocData[@"verticalAccuracy"] = [NSNumber numberWithDouble:curLocation.verticalAccuracy];
    
    locationData[@"gpsData"] = curLocData;
    
    NSMutableDictionary *wifiData = [NSMutableDictionary dictionary];
    
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    
    if (interfaces) {
        NSDictionary *netInfo = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
        wifiData[@"ssid"] = netInfo[@"SSID"];
        wifiData[@"bssid"] = netInfo[@"BSSID"];
    }
    
    locationData[@"wifiData"] = wifiData;
    
    NSMutableDictionary *serializedPostData = [NSMutableDictionary dictionary];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:locationData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    serializedPostData[@"locationData"] = [[NSString alloc] initWithData:postData
                                                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"sent data: %@", serializedPostData[@"locationData"]);
    
    [[MCCClient sharedClient] locationFromiBeacons:serializedPostData
                                         floorPlan:@"full-test-1"
                               withCompletionBlock:^(MCCFloorPlanLocation *floorPlanLocation) {
                                   [self drawPolylineFromStartLocation:floorPlanLocation];
                               }];
}

#pragma mark - Helper Methods

-(void)drawPolylineFromStartLocation:(MCCFloorPlanLocation *)startLocation {
    NSLog(@"Generating polyline");
    
    MCCClient *client = [MCCClient sharedClient];
    
    [client fetchFloorPlan:@"full-test-1"
       withCompletionBlock:^(MCCNavData *navData) {
           
           [client shortestPathOnFloorPlan:@"full-test-1"
                                      from:startLocation.locationId
                                        to:self.endLocation.locationId
                       withCompletionBlock:^(MCCNavPath *path) {
                           
                           // Get the number of points, which is the number of edges + 1
                           NSUInteger numPoints = [path.edges count] + 1;
                           
                           // Allocate the array of coordinates
                           CLLocationCoordinate2D coords[numPoints];
                           
                           // Start with the start of the first edge
                           MCCFloorPlanEdge *firstEdge = [path.edges firstObject];
                           NSLog(@"%@",firstEdge.startLocation.locationId);
                           MCCFloorPlanImageLocation *firstLocation = [navData.mapping coordinatesOfLocation:firstEdge.startLocation.locationId];
                           
                           MCCFloorPlanImageLocation *firstTranslatedLocation =
                           [MCCFloorPlanImageLocation floorPlanImageLocationWithX:firstLocation.x - self.floor1TopLeft.x
                                                                             andY:firstLocation.y - self.floor1TopLeft.y];
                           
                           
                           // Turn the floorplan location into lat-long
                           coords[0] = [self.floor1 coordinateFromFloorPlanImageLocation:firstTranslatedLocation];
                           
                           int i = 1;
                           
                           // Then do the end of all the other edges
                           for (MCCFloorPlanEdge *edge in path.edges) {
                               MCCFloorPlanImageLocation *location = [navData.mapping coordinatesOfLocation:edge.endLocation.locationId];
                               
                               MCCFloorPlanImageLocation *translatedLocation =
                               [MCCFloorPlanImageLocation floorPlanImageLocationWithX:location.x - self.floor1TopLeft.x
                                                                                 andY:location.y - self.floor1TopLeft.y];
                               
                               // Turn the floorplan location into lat-long
                               coords[i] = [self.floor1 coordinateFromFloorPlanImageLocation:translatedLocation];
                               ++i;
                           }
                           
                           self.polyline = [MKPolyline polylineWithCoordinates:coords
                                                                         count:numPoints];
                           
                           
                           [self.mapView addOverlay:self.polyline];
                       }];
       }];

}



@end

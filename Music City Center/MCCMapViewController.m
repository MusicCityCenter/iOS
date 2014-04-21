//
//  MCCViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/3/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCMapViewController.h"
#import "MCCFloorViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"
#import "MCCNavData.h"
#import "MCCFloorPlanLocation.h"
#import "MCCFloorPlan.h"
#import "UIView+Screenshot.h"
#import <GPUImage/GPUImage.h>
#import <MapKit/MapKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>

static NSString * const kCellIdentifier = @"Cell";
static CGFloat const kBlurOffset = 64.0f;


@interface MCCMapViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *events; // MCCEvents
@property (strong, nonatomic) NSMutableArray *eventSearchResults;

@property (strong, nonatomic) NSMutableArray *rooms; // MCCFloorPlanLocations
@property (strong, nonatomic) NSMutableArray *roomSearchResults;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchTableView;
@property (nonatomic) BOOL searching;

// Beacons
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *beacons;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) BOOL useBluetooth;

@property (strong, nonatomic) GPUImageView *blurView;
@property (strong, nonatomic) GPUImageiOSBlurFilter *blurFilter;

@end

@implementation MCCMapViewController

#pragma mark - Custom Getters

// Work Item 8
// The contents array should be populated using MCCNav
// When an item is selected, it should open the appropriate floor plan
// And display a route to that location (from a randomly selected start
// point) on top of the floor plan image. Obtaining and displaying the
// route is the responsibility of the person doing Work Item 9 -- not
// this person.

- (NSMutableArray *)eventSearchResults {
    if (!_eventSearchResults) {
        _eventSearchResults = [NSMutableArray array];
    }
    return _eventSearchResults;
}

- (NSMutableArray *)rooms {
    if (!_rooms) {
        _rooms = [NSMutableArray array];
    }
    return _rooms;
}

- (NSMutableArray *)roomSearchResults {
    if (!_roomSearchResults) {
        _roomSearchResults = [NSMutableArray array];
    }
    return _roomSearchResults;
}

- (GPUImageiOSBlurFilter *)blurFilter {
    if (!_blurFilter) {
        _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        _blurFilter.blurRadiusInPixels = 4.0f;
    }
    
    return _blurFilter;
}

-(UITableView *)searchTableView {
    if (!_searchTableView) {
        
        // We don't want the tableView to end up underneath the Nav Bar, so we need to move it down a bit
        CGRect deviceSize = [UIScreen mainScreen].bounds;
        NSInteger navigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height
                                    + self.navigationController.navigationBar.frame.size.height;
        
        _searchTableView = [[UITableView alloc]
                            initWithFrame:CGRectMake(0, navigationBarHeight,
                                                     deviceSize.size.width, deviceSize.size.height)
                            style:UITableViewStyleGrouped];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    
    return _searchTableView;
}

-(UISearchBar *)searchBar {
    if (!_searchBar) {
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.placeholder = @"Search for Events or Rooms";
        self.searchBar.delegate = self;
    }
    
    return _searchBar;
}

- (CLBeaconRegion *)beaconRegion {
    if (!_beaconRegion) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:@"com.nashvillemusiccitycenter"];
    }
    return _beaconRegion;
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check to see if BTLE is supported
    self.useBluetooth = NO;
    if ([CLLocationManager isMonitoringAvailableForClass:[self.beaconRegion class]] &&
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        
        self.useBluetooth = [CLLocationManager isRangingAvailable];
    }
    
    if (self.useBluetooth) {
        NSLog(@"USING BLUETOOTH");
        
        [self locationManager:self.locationManager didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorized];
    } else {
        NSLog(@"NOT USING BLUETOOTH");
    }
    
    // Put the search bar in the navigation bar
    self.navigationItem.titleView = self.searchBar;
    
    // Set up the table view
    [self.searchTableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.searchTableView.backgroundColor = [UIColor clearColor];
    
    self.searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // We are currently not searching
    self.searching = NO;
    
    // Set up the blur view
    self.blurView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.blurView.clipsToBounds = YES;
    self.blurView.layer.contentsGravity = kCAGravityBottom;
    self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    
    [self.view addSubview:self.blurView];
    
    // Allow the user to exit the search by tapping
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(endSearch)];
    [self.blurView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = 0;
    
    if ([self.eventSearchResults count] > 0) {
        ++numberOfSections;
    }
    if ([self.roomSearchResults count] > 0) {
        ++numberOfSections;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    // If there are no events, then rooms are in section zero
    if ((section == 0 && [self.eventSearchResults count] == 0) || section == 1) {
        numberOfRows = [self.roomSearchResults count];
    } else if (section == 0) {
        numberOfRows = [self.eventSearchResults count];
    }
    
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    
    if ((section == 0 && [self.eventSearchResults count] == 0) || section == 1) {
        title = @"Rooms";
    } else if (section == 0) {
        title = @"Events";
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0 && [self.eventSearchResults count] > 0) {
        MCCEvent *event = self.eventSearchResults[indexPath.row];
        
        cell.textLabel.text = event.name;
    } else {
        MCCFloorPlanLocation *location = self.roomSearchResults[indexPath.row];
        
        cell.textLabel.text = location.locationId;
    }
    
    // Set the backround to clear so you can see the blur effect underneath
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [self.eventSearchResults count] > 0) {
        MCCEvent *event = self.eventSearchResults[indexPath.row];
        
        [self performSegueWithIdentifier:@"PushMap"
                                  sender:[MCCFloorPlanLocation floorPlanLocationWithLocationId:event.locationId
                                                                                       andType:@"room"]];
    } else {
        MCCFloorPlanLocation *location = self.roomSearchResults[indexPath.row];
        
        [self performSegueWithIdentifier:@"PushMap"
                                  sender:location];
    }
    
    [self.searchTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *) view;
    headerView.textLabel.textColor = [UIColor whiteColor];
}

#pragma mark - Search Bar Delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    [self populateEventsAndRooms];
    
    if (!self.searching) {
    
        [self updateBlur];
        
        CGRect deviceSize = [UIScreen mainScreen].bounds;
        
        [UIView animateWithDuration:0.25f animations:^(void){
            self.blurView.frame = CGRectMake(0, kBlurOffset, deviceSize.size.width, deviceSize.size.height);
            self.blurView.layer.contentsRect = CGRectMake(0.0f, (kBlurOffset / deviceSize.size.height), 1.0f, 1.0f);
            self.blurView.layer.contentsScale = 2.0f;
        }];
    }
    self.searching = YES;
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchTableView removeFromSuperview];
    [self endSearch];
}

-(void)endSearch {
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.blurView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    }];
    [self.searchBar resignFirstResponder];
    self.searching = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // If there is text to search, add the table as a subview
    if (!self.searchTableView.superview && searchText.length > 0) {
        [self.view addSubview:self.searchTableView];
    }
    // If there is currently no text to search and there was before, remove the tableview
    else if (self.searchTableView.superview && searchText.length == 0) {
        [self.searchTableView removeFromSuperview];
    }
    // The above is so that the gesture recognizer on the blurview can be accessed when there is no text in the search bar
    
    [self findMatches:searchText];
    [self.searchTableView reloadData];
}

#pragma mark - Blur Effect

- (void)updateBlur {
    UIImage *image = [self.view.superview convertViewToImage];
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    [picture addTarget:self.blurFilter];
    [self.blurFilter addTarget:self.blurView];
    
    [picture processImageWithCompletionHandler:^{
        [self.blurFilter removeAllTargets];
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    self.beacons = beacons;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        self.useBluetooth = [CLLocationManager isRangingAvailable];
        
        // Start monitoring Beacons
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        [self locationManager:self.locationManager didEnterRegion:self.beaconRegion];
        
        // Start getting GPS data
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Helper Methods

- (void)populateEventsAndRooms {
    // Populate contents array with events
    MCCClient *client = [MCCClient sharedClient];
    
    [client events:@"full-test-1" on:[NSDate date] withCompletionBlock:^(NSArray *events) {
        self.events = events;
        
        [client fetchFloorPlan:@"full-test-1" withCompletionBlock:^(MCCNavData *navData) {
            [self.rooms removeAllObjects];
            for (MCCFloorPlanLocation *location in navData.floorPlan.locations) {
                if ([location.type isEqualToString:@"room"]) {
                    [self.rooms addObject:location];
                }
            }
            [self.searchDisplayController.searchResultsTableView reloadData];
        }];
    }];
}

// Find all matching strings
- (void)findMatches:(NSString *)searchText {
    [self.eventSearchResults removeAllObjects];

    for (MCCEvent *event in self.events) {
        NSRange range = [event.name rangeOfString:searchText
                                          options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            [self.eventSearchResults addObject:event];
        }
    }
    
    [self.roomSearchResults removeAllObjects];
    
    for (MCCFloorPlanLocation *location in self.rooms) {
        NSRange range = [location.locationId rangeOfString:searchText
                                                   options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [self.roomSearchResults addObject:location];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushMap"]) {
        if ([sender isKindOfClass:[MCCFloorPlanLocation class]]) {
            MCCFloorPlanLocation *location = (MCCFloorPlanLocation *) sender;
            
            MCCFloorViewController *floorViewController = segue.destinationViewController;
            
            
            if (self.useBluetooth) {
                [floorViewController setPolylineToFloorPlanLocation:location andLocationData:[self locationData]];
            } else {
                // User manually enters his/her location
                MCCFloorPlanLocation *startLocation = [MCCFloorPlanLocation floorPlanLocationWithLocationId:@"110" andType:@"room"];
                
                [floorViewController setPolylineToFloorPlanLocation:location fromFloorPlanLocation:startLocation];
            }
        }
    }
}


- (NSDictionary *)locationData {
    
    // Create dictionary for the data
    NSMutableDictionary *locationData = [NSMutableDictionary dictionary];
    
    // Get Beacon data
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
    
    locationData[@"beaconData"] = beaconData;
    
    
    // Get Location data
    NSMutableDictionary *curLocData = [NSMutableDictionary dictionary];
    curLocData[@"latitude"] = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
    curLocData[@"longitude"] = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
    curLocData[@"altitude"] = [NSNumber numberWithDouble:self.currentLocation.altitude];
    curLocData[@"horizontalAccuracy"] = [NSNumber numberWithDouble:self.currentLocation.horizontalAccuracy];
    curLocData[@"verticalAccuracy"] = [NSNumber numberWithDouble:self.currentLocation.verticalAccuracy];
    
    locationData[@"gpsData"] = curLocData;
    
    
    // Get wifi data
    NSMutableDictionary *wifiData = [NSMutableDictionary dictionary];
    
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    
    if (interfaces) {
        NSDictionary *netInfo = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
        wifiData[@"ssid"] = netInfo[@"SSID"];
        wifiData[@"bssid"] = netInfo[@"BSSID"];
    }
    
    locationData[@"wifiData"] = wifiData;

    
    // Serialize the JSON data into a string
    NSData *postData = [NSJSONSerialization dataWithJSONObject:locationData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSMutableDictionary *serializedPostData = [NSMutableDictionary dictionary];
    serializedPostData[@"locationData"] = [[NSString alloc] initWithData:postData
                                                                encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"generated location data: %@", serializedPostData[@"locationData"]);
    
    return serializedPostData;
    
}

@end

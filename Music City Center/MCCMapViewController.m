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

static NSString * const kCellIdentifier = @"Cell";
static CGFloat const kBlurOffset = 64.0f;


@interface MCCMapViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray *events; // MCCEvents
@property (strong, nonatomic) NSMutableArray *eventSearchResults;

@property (strong, nonatomic) NSMutableArray *rooms; // MCCFloorPlanLocations
@property (strong, nonatomic) NSMutableArray *roomSearchResults;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

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

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class]
                                                forCellReuseIdentifier:kCellIdentifier];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.searchDisplayController.searchResultsTableView addSubview:self.refreshControl];
    
    self.blurView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.blurView.clipsToBounds = YES;
    self.blurView.layer.contentsGravity = kCAGravityBottom;
    self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    
    [self.view addSubview:self.blurView];
    
    // Put the search bar in the nav bar
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self findMatches];

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
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor blueColor];
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *) view;
    headerView.textLabel.textColor = [UIColor whiteColor];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self populateEventsAndRooms];
}

#pragma mark - Search Display Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self populateEventsAndRooms];
    
    [self updateBlur];
    
    CGRect deviceSize = [UIScreen mainScreen].bounds;
    
    [UIView animateWithDuration:0.25f animations:^(void){
        self.blurView.frame = CGRectMake(0, kBlurOffset, deviceSize.size.width, deviceSize.size.height);
        self.blurView.layer.contentsRect = CGRectMake(0.0f, (kBlurOffset / deviceSize.size.height), 1.0f, 1.0f);
        self.blurView.layer.contentsScale = 2.0f;
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIView animateWithDuration:0.25f animations:^{
        self.blurView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    }];
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

#pragma mark - Helper Method

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
            [self.refreshControl endRefreshing];
        }];
    }];
}

// Find all matching strings
- (void)findMatches {
    [self.eventSearchResults removeAllObjects];

    for (MCCEvent *event in self.events) {
        NSRange range = [event.name rangeOfString:self.searchDisplayController.searchBar.text
                                          options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            [self.eventSearchResults addObject:event];
        }
    }
    
    [self.roomSearchResults removeAllObjects];
    
    for (MCCFloorPlanLocation *location in self.rooms) {
        NSRange range = [location.locationId rangeOfString:self.searchDisplayController.searchBar.text
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
            [floorViewController setPolylineFromFloorPlanLocation:location];
        }
    }
}

@end

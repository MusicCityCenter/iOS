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


@property (strong, nonatomic) NSArray *eventContents; // of MCCEvents
@property (strong, nonatomic) NSMutableArray *searchEventContents;

@property (strong, nonatomic) NSMutableArray *roomContents; // of MCCFloorPlanLocations
@property (strong, nonatomic) NSMutableArray *searchRoomContents;

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

- (NSMutableArray *)searchEventContents {
    if (!_searchEventContents) {
        _searchEventContents = [NSMutableArray array];
    }
    
    return _searchEventContents;
}

- (NSMutableArray *)roomContents {
    if (!_roomContents) {
        _roomContents = [NSMutableArray array];
    }
    return _roomContents;
}

- (NSMutableArray *)searchRoomContents {
    if (!_searchRoomContents) {
        _searchRoomContents = [NSMutableArray array];
    }
    return _searchRoomContents;
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
//    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    
    [self.searchDisplayController setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
                             forKey:@"_searchResultsTableViewStyle"];
    
    self.blurView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.blurView.clipsToBounds = YES;
    self.blurView.layer.contentsGravity = kCAGravityBottom;
    self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    
    [self.view addSubview:self.blurView];
    
    // Put the search bar in the nav bar
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    // Populate contents array with events
    MCCClient *client = [MCCClient sharedClient];
    
    [client events:@"full-test-1" on:[NSDate date] withCompletionBlock:^(NSArray *events) {
        self.eventContents = events;
    }];
    
    [client fetchFloorPlan:@"full-test-1" withCompletionBlock:^(MCCNavData *navData) {
        for (MCCFloorPlanLocation *location in navData.floorPlan.locations) {
            if ([location.type isEqualToString:@"room"]) {
                [self.roomContents addObject:location];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self findMatches];
    
    if (section == 0) {
        return [self.searchEventContents count];
    } else if (section == 1) {
        return [self.searchRoomContents count];
    } else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Events";
    } else if (section == 1) {
        return @"Rooms";
    } else {
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        MCCEvent *event = self.searchEventContents[indexPath.row];
        
        cell.textLabel.text = event.name;
    } else if (indexPath.section == 1) {
        MCCFloorPlanLocation *location = self.searchRoomContents[indexPath.row];
        
        cell.textLabel.text = location.locationId;
    }
    
    // Set the backround to clear so you can see the blur effect underneath
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MCCEvent *event = self.searchEventContents[indexPath.row];
        
        [self performSegueWithIdentifier:@"PushMap"
                                  sender:[MCCFloorPlanLocation
                                          floorPlanLocationWithLocationId:event.locationId
                                          andType:@"room"]];
    } else if (indexPath.section == 1) {
        MCCFloorPlanLocation *location = self.searchRoomContents[indexPath.row];
        
        [self performSegueWithIdentifier:@"PushMap" sender:location];
    }
}

#pragma mark - Search Display Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
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

// Find all matching strings
- (void)findMatches {
    [self.searchEventContents removeAllObjects];

    for (MCCEvent *event in self.eventContents) {
        NSRange range = [event.name rangeOfString:self.searchDisplayController.searchBar.text
                                          options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            [self.searchEventContents addObject:event];
        }
    }
    
    [self.searchRoomContents removeAllObjects];
    
    for (MCCFloorPlanLocation *location in self.roomContents) {
        NSRange range = [location.locationId rangeOfString:self.searchDisplayController.searchBar.text
                                                   options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [self.searchRoomContents addObject:location];
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

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
#import "UIView+Screenshot.h"
#import <GPUImage/GPUImage.h>
#import <MapKit/MapKit.h>

static NSString * const kCellIdentifier = @"Cell";
static CGFloat const kBlurOffset = 64.0f;

@interface MCCMapViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>


@property (strong, nonatomic) NSArray *contents; // of MCCEvents
@property (strong, nonatomic) NSMutableArray *searchContents;

@property (strong, nonatomic) GPUImageView *blurView;
@property (strong, nonatomic) GPUImageiOSBlurFilter *blurFilter;

@end

@implementation MCCMapViewController

#pragma mark - Custom Getters

// Work Item 8
// This array should be populated using MCCNav
// When an item is selected, it should open the appropriate floor plan
// And display a route to that location (from a randomly selected start
// point) on top of the floor plan image. Obtaining and displaying the
// route is the responsibility of the person doing Work Item 9 -- not
// this person.

// *** NO NEED FOR THIS CUSTOM GETTER ANYMORE ? ****

//- (NSArray *)contents {
//    if (!_contents) {
//        _contents = @[// L4
//                      @"Grand Ballroom", @"L4 Balcony",
//                      @"Room 401", @"Room 402", @"Room 403",
//                      // L3
//                      @"Hall A1", @"Hall A2", @"Hall B", @"Hall C", @"Hall D",
//                      @"L3 Terrace", @"Lounge",
//                      // L2
//                      @"L2 Balcony",
//                      @"Room 201", @"Room 202", @"Room 203", @"Room 204", @"Room 205",
//                      @"Room 206", @"Room 207", @"Room 208", @"Room 209", @"Room 210",
//                      @"Room 211", @"Room 212", @"Room 213", @"Room 214",
//                      // L1M
//                      @"Davidson Ballroom", @"Board Room A", @"Board Room B", @"L1M Balcony",
//                      // L1
//                      @"L1 Terrace",
//                      @"Room 101", @"Room 102", @"Room 103", @"Room 104", @"Room 105",
//                      @"Room 106", @"Room 107", @"Room 108", @"Room 109", @"Room 110"];
//    }
//    
//    return _contents;
//}

- (NSMutableArray *)searchContents {
    if (!_searchContents) {
        _searchContents = [NSMutableArray array];
    }
    
    return _searchContents;
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
        self.contents = events;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self findMatches];
    
    return [self.searchContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    
    MCCEvent *event = self.searchContents[indexPath.row];
    
    cell.textLabel.text = event.name;
    
    // Set the backround to clear so you can see the blur effect underneath
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCCEvent *event = self.searchContents[indexPath.row];
    
    [self performSegueWithIdentifier:@"openMapView" sender:event];
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
    [self.searchContents removeAllObjects];

    for (MCCEvent *event in self.contents) {
        NSRange range = [event.name rangeOfString:self.searchDisplayController.searchBar.text
                                          options:NSCaseInsensitiveSearch];
        
        if (range.location != NSNotFound) {
            [self.searchContents addObject:event];
        }
    }
}

@end

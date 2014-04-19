//
//  MCCEventsViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 3/31/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventsPageViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"
#import "MCCEventsTableViewController.h"
#import "MCCEventDetailViewController.h"
#import "MCCPageViewControllerDelegate.h"
#import "MCCPageViewControllerDataSource.h"
#import "MCCConferencePickerViewController.h"

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsPageViewController () <UISearchBarDelegate>

@property (strong, nonatomic) MCCPageViewControllerDelegate *pageViewControllerDelegate;
@property (strong, nonatomic) MCCPageViewControllerDataSource *pageViewControllerDataSource;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *conferenceButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *eventsYesterday;
@property (strong, nonatomic) NSArray *eventsToday;
@property (strong, nonatomic) NSArray *eventsTomorrow;


@end

@implementation MCCEventsPageViewController

#pragma mark - Custom Getters

- (MCCPageViewControllerDelegate *)pageViewControllerDelegate {
    if (!_pageViewControllerDelegate) {
        _pageViewControllerDelegate = [MCCPageViewControllerDelegate pageViewControllerDelegateWithSegmentedControl:self.segmentedControl];
    }
    
    return _pageViewControllerDelegate;
}

- (MCCPageViewControllerDataSource *)pageViewControllerDataSource {
    if (!_pageViewControllerDataSource) {
        _pageViewControllerDataSource = [[MCCPageViewControllerDataSource alloc] init];
    }
    
    return _pageViewControllerDataSource;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Events";
    
    self.delegate = self.pageViewControllerDelegate;
    self.dataSource = self.pageViewControllerDataSource;
    
    MCCEventsTableViewController *initialEventsTableViewController = [[MCCEventsTableViewController alloc] init];
    initialEventsTableViewController.date = [NSDate date];
    initialEventsTableViewController.pageNumber = 1;
    
    [self setViewControllers:@[initialEventsTableViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    NSTimeInterval day = 60*60*24;
    NSDate *tomorrow = [[NSDate alloc]
                           initWithTimeIntervalSinceNow:day];
    NSDate *yesterday = [[NSDate alloc]
                           initWithTimeIntervalSinceNow:-day];
    NSDate *today = [NSDate date];
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:yesterday
                 withCompletionBlock:^(NSArray *events) {
                     self.eventsYesterday = events;
                 }];
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:today
                 withCompletionBlock:^(NSArray *events) {
                     self.eventsToday = events;
                 }];
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:tomorrow
                 withCompletionBlock:^(NSArray *events) {
                     self.eventsTomorrow = events;
                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushEventDetail"]) {
        if ([sender isKindOfClass:[MCCEvent class]]) {
            MCCEventDetailViewController *eventDetailViewController = segue.destinationViewController;
            eventDetailViewController.event = sender;
        }
    } else if ([segue.identifier isEqualToString:@"ConferenceModal"]) {
        //MCCConferencePickerViewController *conferenceViewController = segue.destinationViewController;
        NSMutableArray *conferenceList = [[NSMutableArray alloc] init];
        //[myArray addObject:otherArray];
        for (MCCEvent *event in self.eventsYesterday){
            if ([conferenceList indexOfObject:event.conference] != NSNotFound) {
                [conferenceList addObject:event.conference];
            }
        }
        for (MCCEvent *event in self.eventsToday){
            if ([conferenceList indexOfObject:event.conference] != NSNotFound) {
                [conferenceList addObject:event.conference];
            }
        }
        for (MCCEvent *event in self.eventsTomorrow){
            if ([conferenceList indexOfObject:event.conference] != NSNotFound) {
                [conferenceList addObject:event.conference];
            }
        }
        [conferenceList addObject:@"test Conference 1"];
        [conferenceList addObject:@"test Conference 2"];
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        MCCConferencePickerViewController *controller = (MCCConferencePickerViewController *)navController.topViewController;
        [controller conferencesToDisplay:conferenceList];
    }
}

@end

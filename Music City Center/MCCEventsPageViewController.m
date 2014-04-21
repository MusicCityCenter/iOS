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
#import "MCCFilterViewController.h"

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsPageViewController () <UISearchBarDelegate>

@property (strong, nonatomic) MCCPageViewControllerDelegate *pageViewControllerDelegate;
@property (strong, nonatomic) MCCPageViewControllerDataSource *pageViewControllerDataSource;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *conferenceButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *eventsYesterday;
@property (strong, nonatomic) NSArray *eventsToday;
@property (strong, nonatomic) NSArray *eventsTomorrow;
@property (nonatomic) NSInteger lowerHour;
@property (nonatomic) NSInteger lowerMinute;
@property (nonatomic) NSInteger upperHour;
@property (nonatomic) NSInteger upperMinute;
@property (strong, nonatomic) NSString *conference;


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
    
    if (!self.lowerHour){
        self.lowerHour = 0;
        self.lowerMinute = 0;
    }
    if (!self.upperHour){
        self.upperHour = 23;
        self.upperMinute = 59;
    }
    
    MCCEventsTableViewController *initialEventsTableViewController = [[MCCEventsTableViewController alloc] init];
    initialEventsTableViewController.date = [NSDate date];
    initialEventsTableViewController.pageNumber = 1;
    initialEventsTableViewController.lowerHour = self.lowerHour;
    initialEventsTableViewController.lowerMinute = self.lowerMinute;
    initialEventsTableViewController.upperHour = self.upperHour;
    initialEventsTableViewController.upperMinute = self.upperMinute;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fromDateSet:)
                                                 name:@"MODELVIEW DISMISS1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toDateSet:)
                                                 name:@"MODELVIEW DISMISS2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterConference:)
                                                 name:@"CONFERENCE DISMISS" object:nil];
    
    /*NSTimeInterval gap1 = 60*60*6;
    NSTimeInterval gap2 = 60*60*6-1;
    NSDate *displayTime1 = [[NSDate alloc]
                            initWithTimeIntervalSince1970:gap1];
    NSDate *displayTime2 = [[NSDate alloc]
                            initWithTimeIntervalSince1970:gap2];
    self.fromDate = displayTime1;
    self.toDate = displayTime2;*/
    

}


-(void)filterConference:(NSNotification *)notice{
    self.conference = [notice object];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fromDateSet:(NSNotification *)notice{
    NSDate *date = [notice object];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    self.lowerHour = [components hour];
    self.lowerMinute = [components minute];
    NSLog(@"lower bound: %d:%d", self.lowerHour, self.lowerMinute);
}

-(void)toDateSet:(NSNotification *)notice{
    NSDate *date = [notice object];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    self.upperHour = [components hour];
    self.upperMinute = [components minute];
    NSLog(@"upper bound: %d:%d", self.upperHour, self.upperMinute);
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
    } else if ([segue.identifier isEqualToString:@"PresentFilter"]) {
        
        
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        MCCFilterViewController *controller = (MCCFilterViewController *)navController.topViewController;
        NSInteger t1 = self.lowerHour;
        NSInteger t2 = self.lowerMinute;
        NSInteger t3 = self.upperHour;
        NSInteger t4 = self.upperMinute;
        [controller setBoundsforLowerHour:self.lowerHour lowerMinute:self.lowerMinute upperHour:self.upperHour upperMinute:self.upperMinute];

    }
}

@end

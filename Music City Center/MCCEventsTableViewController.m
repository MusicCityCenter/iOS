//
//  MCCEventsTableViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 3/31/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventsTableViewController.h"
#import "MCCConferencePickerViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"

static NSString * const kCellIdentifier = @"EventCell";

@interface MCCEventsTableViewController ()

@property (nonatomic, copy) NSArray *events;
@property (nonatomic, copy) NSString *conference;
@property (nonatomic) NSInteger lowerTimeConstraint;
@property (nonatomic) NSInteger upperTimeConstraint;
@property (nonatomic) BOOL constrained;
@property (strong, nonatomic) NSMutableArray *eventsSectioned;

@end

@implementation MCCEventsTableViewController

#pragma mark - Custom Setter

- (void)setEvents:(NSArray *)events {
    if (![_events isEqualToArray:events]) {
        _events = events;
        
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)eventsSectioned {
    if (!_eventsSectioned) {
        _eventsSectioned = [NSMutableArray array];
    }
    
    return _eventsSectioned;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.lowerHour){
        self.lowerHour = 0;
        self.lowerMinute = 0;
    }
    if (!self.upperHour){
        self.upperHour = 23;
        self.upperMinute = 59;
    }
    [self.eventsSectioned removeAllObjects];
    self.eventsSectioned = [[NSMutableArray alloc] init];
    NSMutableArray *firstDimension = [[NSMutableArray alloc] init];
    for (int i = 0; i < 24; i++)
    {
        NSMutableArray *secondDimension = [[NSMutableArray alloc] init];
        [firstDimension addObject:secondDimension];
    }
    self.eventsSectioned = [NSMutableArray arrayWithArray:firstDimension];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
/*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"MODELVIEW DISMISS1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"MODELVIEW DISMISS2" object:nil];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fromDateSet:)
                                                 name:@"MODELVIEW DISMISS1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toDateSet:)
                                                 name:@"MODELVIEW DISMISS2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"CONFERENCE DISMISS" object:nil];
    
    // TODO - Change this from full-test-1
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:self.date
                 withCompletionBlock:^(NSArray *events) {
                     self.events = events;
                     for (int i = 0; i < 24; i++)
                     {
                         [self.eventsSectioned[i] removeAllObjects];
                     }
                     for (MCCEvent *event in events){
                         NSString *what = event.name;
                         NSInteger startTime = (NSInteger) event.startTime;
                         NSInteger hourStart = (event.startTime/60);
                         NSInteger lowerBound = (self.lowerHour * 60 + self.lowerMinute);
                         NSInteger upperBound = (self.upperHour * 60 + self.upperMinute);
                         NSInteger upperHour = self.upperHour;
                         
                         if (event.startTime >= lowerBound && event.startTime <= upperBound && (([self.conference isEqualToString:event.conference]) || (self.conference == nil))){
                             NSMutableArray *section = self.eventsSectioned[hourStart];
                             [section addObject:event];
                             NSMutableArray *debug = self.eventsSectioned;
                             NSLog(@"object added");
                         }
                         NSLog(@"here!: %@", event.name);
                     }
                     [self.tableView reloadData];
                 }];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [self.events sortedArrayUsingDescriptors:sortDescriptors];
    self.events = sortedArray;
    NSLog(@"conference: %@", self.conference);
     


    
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
    [self refreshTable];
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
    [self refreshTable];
}

- (void) refresh:(NSNotification *)notice{
    self.conference = [notice object];
    NSLog(@"Notification conference: %@", self.conference);
    [self refreshTable];
}

- (void) refreshTable{
    // TODO - Change this from full-test-1
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:self.date
                 withCompletionBlock:^(NSArray *events) {
                     self.events = events;
                     for (int i = 0; i < 24; i++)
                     {
                         [self.eventsSectioned[i] removeAllObjects];
                     }
                     for (MCCEvent *event in events){
                         NSString *what = event.name;
                         NSInteger startTime = (NSInteger) event.startTime;
                         NSInteger hourStart = (event.startTime/60);
                         NSInteger lowerBound = (self.lowerHour * 60 + self.lowerMinute);
                         NSInteger upperBound = (self.upperHour * 60 + self.upperMinute);
                         NSInteger lowerHour = self.lowerHour;
                         NSString *debugConference = event.conference;
                         NSString *selfConference = self.conference;
                         if (event.startTime >= lowerBound && event.startTime <= upperBound && (([self.conference isEqualToString:event.conference]) || (self.conference == nil))){
                             NSLog(@"Refresh conference: %@", self.conference);
                             NSMutableArray *section = self.eventsSectioned[hourStart];
                             [section addObject:event];
                             NSMutableArray *debug = self.eventsSectioned;
                             NSLog(@"Refresh: object added");
                         }
                         NSLog(@"Refresh: here!: %@", event.name);
                     }
                     [self.tableView reloadData];
                 }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.events count];
    NSInteger lowerBound = (self.lowerHour * 60 + self.lowerMinute);
    NSInteger upperBound = (self.upperHour * 60 + self.upperMinute);
    NSInteger count = 0;
    NSMutableArray *debugging = self.eventsSectioned;
    for (MCCEvent *event in self.eventsSectioned[section]){
        if (event.startTime >= lowerBound && event.startTime <= upperBound && (([self.conference isEqualToString:event.conference]) || (self.conference == nil))){
            count++;
        }
    }
    return count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
  
    MCCEvent *event = self.eventsSectioned[indexPath.section][indexPath.row];
    NSLog(@"ummm%d", indexPath.row);

    cell.textLabel.text = event.name;
    NSInteger hourStart = event.startTime/60;
    NSInteger minuteStart = event.startTime%60;
    NSInteger hourEnd = event.endTime/60;
    NSInteger minuteEnd = event.endTime%60;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Room %@ from %d:%02d - %d:%02d", event.locationId, hourStart, minuteStart, hourEnd, minuteEnd];
    cell.detailTextLabel.textColor = [UIColor blueColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCCEvent *event = self.events[indexPath.row];
    
    if ([self.parentViewController isKindOfClass:[UIPageViewController class]]) {
        [self.parentViewController performSegueWithIdentifier:@"PushEventDetail"
                                                       sender:event];
    }
}

#pragma Table View Sections

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return [self.monthTitle count];
    return 24;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [self.monthTitle objectAtIndex:section];
    NSArray *myArray = [[NSArray alloc] initWithObjects:@"12am", @"1am", @"2am", @"3am", @"4am", @"5am", @"6am", @"7am", @"8am", @"9am", @"10am", @"11am", @"12pm", @"1pm", @"2pm", @"3pm", @"4pm", @"5pm", @"6pm", @"7pm", @"8pm", @"9pm", @"10pm", @"11pm", nil];
    NSString *headerTitle = myArray[section];
    return headerTitle;
}




@end

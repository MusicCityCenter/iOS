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
@property (nonatomic, copy) NSMutableArray *eventsSectioned;

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
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];


    
    // TODO - Change this from full-test-1
    [[MCCClient sharedClient] events:@"full-test-1"
                                  on:self.date
                 withCompletionBlock:^(NSArray *events) {
                     self.events = events;
                     self.eventsSectioned = [[NSMutableArray alloc] init];
                     NSMutableArray *firstDimension = [[NSMutableArray alloc] init];
                     for (int i = 0; i < 24; i++)
                     {
                         NSMutableArray *secondDimension = [[NSMutableArray alloc] init];
                         [firstDimension addObject:secondDimension];
                     }
                     self.eventsSectioned = [NSMutableArray arrayWithArray:firstDimension];
                     for (MCCEvent *event in events){
                         NSString *what = event.name;
                         NSInteger startTime = (NSInteger) event.startTime;
                         NSInteger hour = (event.startTime/60);
                         //[self.eventsSectioned insertObject:event atIndex:hour];
                         NSLog(@"here!: %@", event.name);
                     }
                     [self.tableView reloadData];
                 }];
    /*
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [self.events sortedArrayUsingDescriptors:sortDescriptors];
    self.events = sortedArray;
     */


    
    for (MCCEvent *event in self.events){
        [self.eventsSectioned insertObject:event atIndex:(event.startTime/60)];
        NSLog(@"here!: %@", event.name);
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.events count];
    NSInteger count = 0;
    for (MCCEvent *event in self.events){
        if (((event.startTime/60) == section)){
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
  
    MCCEvent *event = self.events[indexPath.row];
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

//
//  MCCEventsTableViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 3/31/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventsTableViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"

static NSString * const kCellIdentifier = @"EventCell";

@interface MCCEventsTableViewController ()

@property (nonatomic, copy) NSArray *events;

@end

@implementation MCCEventsTableViewController

#pragma mark - Custom Setter

- (void)setEvents:(NSArray *)events {
    if (![_events isEqualToArray:events]) {
        _events = events;
        
        [self.tableView reloadData];
    }
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
                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
    NSInteger count = 0;
    for (MCCEvent *event in self.events){
        if (((event.startTime/60) == section)){
            count++;
        }
    }
    NSLog(@"this called");
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                          //  forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
  
    MCCEvent *event = self.events[indexPath.row];
    
    cell.textLabel.text = event.name;
    //cell.detailTextLabel.text = event.locationId;
    NSInteger hourStart = event.startTime/60;
    NSInteger minuteStart = event.startTime%60;
    NSInteger hourEnd = event.endTime/60;
    NSInteger minuteEnd = event.endTime%60;

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %d:%02d - %d:%02d", event.locationId, hourStart, minuteStart, hourEnd, minuteEnd];
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

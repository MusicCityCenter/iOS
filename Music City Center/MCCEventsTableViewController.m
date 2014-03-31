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

@property (strong, nonatomic) NSArray *events;

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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    
    MCCEvent *event = self.events[indexPath.row];
    
    cell.textLabel.text = event.name;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

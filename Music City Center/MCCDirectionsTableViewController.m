//
//  MCCDirectionsTableViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 3/18/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCDirectionsTableViewController.h"

@interface MCCDirectionsTableViewController ()

@property (nonatomic, copy) NSArray *directions;

@end

@implementation MCCDirectionsTableViewController

#pragma mark - Custom Getter

- (NSArray *)directions {
    if (!_directions) {
        _directions = @[@"Walk left until you reach something.",
                        @"Keep going until you reach something else.",
                        @"Turn left and go up the stairs.",
                        @"Keep turning and walking."];
    }
    
    return _directions;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.directions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DirectionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = self.directions[indexPath.row];
    
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

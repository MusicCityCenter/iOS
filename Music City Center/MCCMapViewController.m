//
//  MCCViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/3/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCMapViewController.h"
#import "MCCFloorViewController.h"

static NSString * const identifier = @"Cell";


@interface MCCMapViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSArray* contents;
@property (strong, nonatomic) NSMutableArray* searchContents;

@end

@implementation MCCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contents = [NSArray arrayWithObjects:
                     // L4
                     @"Grand Ballroom", @"L4 Balcony",
                     @"Room 401", @"Room 402", @"Room 403",
                     // L3
                     @"Hall A1", @"Hall A2", @"Hall B", @"Hall C", @"Hall D",
                     @"L3 Terrace", @"Lounge",
                     // L2
                     @"L2 Balcony",
                     @"Room 201", @"Room 202", @"Room 203", @"Room 204", @"Room 205",
                     @"Room 206", @"Room 207", @"Room 208", @"Room 209", @"Room 210",
                     @"Room 211", @"Room 212", @"Room 213", @"Room 214",
                     // L1M
                     @"Davidson Ballroom", @"Board Room A", @"Board Room B", @"L1M Balcony",
                     // L1
                     @"L1 Terrace",
                     @"Room 101", @"Room 102", @"Room 103", @"Room 104", @"Room 105",
                     @"Room 106", @"Room 107", @"Room 108", @"Room 109", @"Room 110",
                     nil];
    
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class]
                                                forCellReuseIdentifier:identifier];
    
    // Put the search bar in the nav bar
    [self.searchDisplayController.searchBar removeFromSuperview];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    // Set the tableview background to clear so the toolbar can be seen underneath
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    
    // Set the table background view to be a toolbar - the toolbar provides the 'blur' effect
    // **** This is kind of a hack, so I'm not sure if we should actually do this ****
    self.searchDisplayController.searchResultsTableView.backgroundView = [[UIToolbar alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Find all matching strings
- (void)findMatches {
    self.searchContents = [[NSMutableArray alloc] init];
    for (NSString* str in self.contents) {
        NSRange range = [str rangeOfString:self.searchDisplayController.searchBar.text options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [self.searchContents addObject:str];
        }
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self findMatches];
    return [self.searchContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self.searchContents objectAtIndex:indexPath.row];
    
    // Set the backround to clear so you can see the blur effect underneath
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

@end

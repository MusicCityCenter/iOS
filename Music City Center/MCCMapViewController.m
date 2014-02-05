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
    
    self.contents = [NSArray arrayWithObjects:@"Davidson Ballroom", @"Grand Ballroom", @"Room 101", nil];
    
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class]
                                                forCellReuseIdentifier:identifier];
    
    self.searchDisplayController.searchResultsTableView.alpha = 0.7;
    
    [self.searchDisplayController.searchBar removeFromSuperview];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    return cell;
}

@end

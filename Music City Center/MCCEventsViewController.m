//
//  MCCEventsViewController.m
//  Music City Center
//
//  Created by Marissa Montgomery on 3/18/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventsViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"
#import "MCCMapViewController.h"
#import "MCCFloorViewController.h"

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray * contents;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISegmentedControl *segmented;
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UITableView * tableView;


@end


@implementation MCCEventsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, 300, 400)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class]
                                                forCellReuseIdentifier:kCellIdentifier];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor darkGrayColor];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [self.view addSubview:self.searchBar];

    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(10, 44, 300, 40);
    [self.view addSubview:self.label];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Soon", @"Near Me", @"All", nil];
    
    self.segmented = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmented.frame = CGRectMake(16, 50, 290, 35);
    self.segmented.selectedSegmentIndex = 1;
    self.segmented.tintColor = [UIColor darkGrayColor];
    [self.view addSubview:self.segmented];
    
    
    // Do any additional setup after loading the view.
    // Populate contents array with events
    [[MCCClient sharedClient] events:@"full-test-1" on:[NSDate date] withCompletionBlock:^(NSArray *events) {
        self.contents = events;
        [self.tableView reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.contents){
        return 0;
        
    }
    NSArray* myContents = self.contents;
    return [myContents count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    MCCEvent *event = self.contents[indexPath.row];
    
    cell.textLabel.text = event.name;
    
    return cell;

}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCCEvent *event = self.contents[indexPath.row];
    
    [self performSegueWithIdentifier:@"PushMap" sender:event];
}





@end

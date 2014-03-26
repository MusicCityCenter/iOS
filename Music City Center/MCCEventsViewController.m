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
#import "MCCEventDetailViewController.h"

#define NUM_DAYS        3

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray * contents;
@property (strong, nonatomic) NSArray * contentsToday;
@property (strong, nonatomic) NSArray * contentsTomorrow;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISegmentedControl *segmented;
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UITableView * tableViewYesterday;
@property (strong, nonatomic) UITableView * tableView2;
@property (strong, nonatomic) UITableView * tableView3;
@property (strong, nonatomic) UIScrollView * scrollView;

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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    int x = self.view.frame.size.width;
    for (int i = 0; i < NUM_DAYS-1; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 50, 40)];
        [button setTitle:[NSString stringWithFormat:@"Day %d", i] forState:UIControlStateNormal];
        switch (i) {
            case 0:
                [button addTarget:self
                           action:@selector(sideScrollToPage0)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Yesterday" forState:UIControlStateNormal];
                break;
            case 1:
                [button addTarget:self
                           action:@selector(sideScrollToPage1)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Today" forState:UIControlStateNormal];
                break;
            case 2:
                [button addTarget:self
                           action:@selector(sideScrollToPage2)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Tomorrow" forState:UIControlStateNormal];
                break;
            default:
                break;
        }

            [button setTitle:@"<" forState:UIControlStateNormal];
        
        [self.scrollView addSubview:button];
        
        x += self.view.frame.size.width;
    }
    
    int x2 = self.view.frame.size.width - 50;
    for (int i = 1; i < NUM_DAYS; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x2, 0, 50, 40)];
        [button setTitle:[NSString stringWithFormat:@"Day %d", i] forState:UIControlStateNormal];
        switch (i) {
            case 0:
                [button addTarget:self
                           action:@selector(sideScrollToPage0)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Yesterday" forState:UIControlStateNormal];
                break;
            case 1:
                [button addTarget:self
                           action:@selector(sideScrollToPage1)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Today" forState:UIControlStateNormal];
                break;
            case 2:
                [button addTarget:self
                           action:@selector(sideScrollToPage2)
                 forControlEvents:UIControlEventTouchUpInside];
                //[button setTitle:@"Tomorrow" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
            [button setTitle:@">" forState:UIControlStateNormal];
 
        [self.scrollView addSubview:button];
        
        x2 += self.view.frame.size.width;
    }
    
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *labelYesterday = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *labelToday = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 40)];
    UILabel *labelTomorrow = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, 40)];
    labelYesterday.text = @"Yesterday";
    labelToday.text = @"Today";
    labelTomorrow.text = @"Tomorrow";
    labelYesterday.textAlignment = NSTextAlignmentCenter;
    labelToday.textAlignment = NSTextAlignmentCenter;
    labelTomorrow.textAlignment = NSTextAlignmentCenter;
    labelYesterday.textColor = [UIColor whiteColor];
    labelToday.textColor = [UIColor whiteColor];
    labelTomorrow.textColor = [UIColor whiteColor];
    
    
    [self.tableViewYesterday registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    self.view.backgroundColor = [UIColor lightGrayColor];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.tableViewYesterday = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, screenWidth, screenHeight-105)];
    self.tableViewYesterday.delegate = self;
    self.tableViewYesterday.dataSource = self;
    [self.scrollView addSubview:self.tableViewYesterday];
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth, 43, screenWidth, screenHeight-105)];
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth*2, 43, screenWidth, screenHeight-105)];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView3.delegate = self;
    self.tableView3.dataSource = self;
    [self.scrollView addSubview:self.tableView2];
    [self.scrollView addSubview:self.tableView3];
    
    int width = self.view.frame.size.width;
    
    [self.scrollView scrollRectToVisible:CGRectMake(width*2, 300/2.0, 1,1) animated:NO];
    [self.scrollView setPagingEnabled:YES];
    
    [self.scrollView addSubview:labelYesterday];
    [self.scrollView addSubview:labelToday];
    [self.scrollView addSubview:labelTomorrow];
    
    [self.view addSubview:self.scrollView];

    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(10, 20, 300, 40);
    [self.view addSubview:self.label];
    NSArray *itemArray = [[NSArray alloc] init];
    itemArray = [NSArray arrayWithObjects: @"Near Me", @"All", nil];
    
    self.segmented = [[UISegmentedControl alloc] initWithItems:itemArray];
    self.segmented.frame = CGRectMake(10, 80, 290, 25);
    self.segmented.selectedSegmentIndex = 1;
    self.segmented.tintColor = [UIColor whiteColor];
    [self.view addSubview:self.segmented];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrow = [[NSDate alloc]
                        initWithTimeIntervalSinceNow:secondsPerDay];
    NSDate *yesterday = [[NSDate alloc]
                         initWithTimeIntervalSinceNow:-secondsPerDay];
    // Do any additional setup after loading the view.
    // Populate contents array with events
    [[MCCClient sharedClient] events:@"full-test-1" on:yesterday withCompletionBlock:^(NSArray *events) {
        self.contents = events;
        [self.tableViewYesterday reloadData];
    }];
    [[MCCClient sharedClient] events:@"full-test-1" on:[NSDate date] withCompletionBlock:^(NSArray *events) {
        self.contentsToday = events;
        [self.tableView2 reloadData];
    }];
    [[MCCClient sharedClient] events:@"full-test-1" on:tomorrow withCompletionBlock:^(NSArray *events) {
        self.contentsTomorrow = events;
        [self.tableView3 reloadData];
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
    if ([tableView isEqual:_tableViewYesterday]){
        
    
        if (!self.contents){
            return 0;
        
        }
        NSArray* myContents = [[NSArray alloc] init];
        myContents = self.contents;
        
        return [myContents count];
    } else if ([tableView isEqual:_tableView2]){
        if (!self.contentsToday){
            return 0;
            
        }
        NSArray* myContents = [[NSArray alloc] init];
        myContents = self.contentsToday;
        
        return [myContents count];
    } else {
        if (!self.contentsTomorrow){
            return 0;
            
        }
        NSArray* myContents = [[NSArray alloc] init];
        myContents = self.contentsTomorrow;
        
        return [myContents count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:simpleTableIdentifier];
    }
    
    MCCEvent *event = [[MCCEvent alloc] init];
    
    if ([tableView isEqual:_tableViewYesterday]){
        event = self.contents[indexPath.row];
    } else if ([tableView isEqual:_tableView2]){
        event = self.contentsToday[indexPath.row];
    } else {
        event = self.contentsTomorrow[indexPath.row];
    }
    
    
    
    
    cell.textLabel.text = event.name;
    NSArray *randomTimesArray = [[NSArray alloc] init];
    randomTimesArray = [NSArray arrayWithObjects:@"6:00 PM in Ballroom A (Today)", @"8:30 PM in Room 101 (Tomorrow)", @"Now in Hallway B", @"12:00 PM in Ballroom B (Tuesday)", @"1 PM in Room 101 (Today)", nil];
    if (indexPath.row < randomTimesArray.count){
        cell.detailTextLabel.text = randomTimesArray[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:0.027 green:0.463 blue:0.729 alpha:1]; /*#0776ba*/
    
    return cell;

}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCCEvent *event = [[MCCEvent alloc] init];
    
    if ([tableView isEqual:_tableViewYesterday]){
        event = self.contents[indexPath.row];
    } else if ([tableView isEqual:_tableView2]){
        event = self.contentsToday[indexPath.row];
    } else {
        event = self.contentsTomorrow[indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"PushEventDetail" sender:event];
    /*
    MCCEventDetailViewController* eventDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCEventDetailViewController"];
    eventDetailVC.tweet = [self.contents objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
     */
    /*
    DetailVC *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    dvc.tweet = [self.tweetsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];*/
}

#pragma mark - Scrolling to pages


- (void) sideScrollToPage0{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width,1) animated:YES];
}

- (void) sideScrollToPage1{
    [self.scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,1) animated:YES];
}

- (void) sideScrollToPage2{
    [self.scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width,1) animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PushEventDetail"]) {
        if ([sender isKindOfClass:[MCCEvent class]]) {
            MCCEvent *event = [[MCCEvent alloc] init];
            event = (MCCEvent *) sender;
            
            MCCEventDetailViewController *eventDetailViewController = [[MCCEventDetailViewController alloc] init];
            eventDetailViewController = segue.destinationViewController;
            [eventDetailViewController setEvent:event];
            eventDetailViewController.event1 = event;
        }
    }
     
}





@end

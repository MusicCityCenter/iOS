//
//  MCCEventsViewController.m
//  Music City Center
//
//  Created by Marissa Montgomery on 3/18/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventsPageViewController.h"
#import "MCCClient.h"
#import "MCCEvent.h"
#import "MCCMapViewController.h"
#import "MCCFloorViewController.h"
#import "MCCEventsTableViewController.h"
#import "MCCEventDetailViewController.h"
#import "MCCPageViewControllerDelegate.h"
#import "MCCPageViewControllerDataSource.h"

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsPageViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSArray *contentsToday;
@property (strong, nonatomic) NSArray *contentsTomorrow;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) MCCPageViewControllerDelegate *pageViewControllerDelegate;
@property (strong, nonatomic) MCCPageViewControllerDataSource *pageViewControllerDataSource;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *conferenceButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
    
    self.delegate = self.pageViewControllerDelegate;
    self.dataSource = self.pageViewControllerDataSource;
    
    MCCEventsTableViewController *initialEventsTableViewController = [[MCCEventsTableViewController alloc] init];
    initialEventsTableViewController.date = [NSDate date];
    initialEventsTableViewController.pageNumber = 1;
    
    [self setViewControllers:@[initialEventsTableViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:^(BOOL finished) {
                      // Completed
                  }];
    
    /*[self setNeedsStatusBarAppearanceUpdate];
    
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
    }];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

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

/*#pragma mark - Scrolling to pages

- (void) sideScrollToPage0{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width,1) animated:YES];
}

- (void) sideScrollToPage1{
    [self.scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,1) animated:YES];
}

- (void) sideScrollToPage2{
    [self.scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width,1) animated:YES];
}*/

@end

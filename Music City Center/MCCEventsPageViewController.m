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
#import "MCCEventsTableViewController.h"
#import "MCCEventDetailViewController.h"
#import "MCCPageViewControllerDelegate.h"
#import "MCCPageViewControllerDataSource.h"

static NSString * const kCellIdentifier = @"Cell";

@interface MCCEventsPageViewController () <UISearchBarDelegate>

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
                    animated:NO
                  completion:nil];
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

@end

//
//  MCCPageViewControllerDelegate.m
//  Music City Center
//
//  Created by Seth Friedman on 3/30/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCPageViewControllerDataSource.h"
#import "MCCEventsTableViewController.h"

@interface MCCPageViewControllerDataSource ()

@property (strong, nonatomic) NSDateComponents *previousComponents;
@property (strong, nonatomic) NSDateComponents *nextComponents;

@end

@implementation MCCPageViewControllerDataSource

#pragma mark - Custom Getters

- (NSDateComponents *)previousComponents {
    if (!_previousComponents) {
        _previousComponents = [[NSDateComponents alloc] init];
        _previousComponents.day = -1;
    }
    
    return _previousComponents;
}

- (NSDateComponents *)nextComponents {
    if (!_nextComponents) {
        _nextComponents = [[NSDateComponents alloc] init];
        _nextComponents.day = 1;
    }
    
    return _nextComponents;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    MCCEventsTableViewController *currentEventsTableViewController = (MCCEventsTableViewController *)viewController;
    
    NSDate *previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:self.previousComponents
                                                                         toDate:currentEventsTableViewController.date
                                                                        options:0];
    
    MCCEventsTableViewController *previousEventsTableViewController = [[MCCEventsTableViewController alloc] init];
    previousEventsTableViewController.date = previousDate;
    
    return previousEventsTableViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    MCCEventsTableViewController *currentEventsTableViewController = (MCCEventsTableViewController *)viewController;
    
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:self.nextComponents
                                                                     toDate:currentEventsTableViewController.date
                                                                    options:0];
    
    MCCEventsTableViewController *nextEventsTableViewController = [[MCCEventsTableViewController alloc] init];
    nextEventsTableViewController.date = nextDate;
    
    return nextEventsTableViewController;
}

@end

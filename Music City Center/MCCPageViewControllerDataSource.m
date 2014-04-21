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

@property (strong, nonatomic) NSDateComponents *twoDaysAgoComponents;
@property (strong, nonatomic) NSDateComponents *previousDayComponents;

@property (strong, nonatomic) NSDateComponents *nextComponents;
@property (strong, nonatomic) NSDateComponents *twoDaysLaterComponents;

@end

@implementation MCCPageViewControllerDataSource

#pragma mark - Custom Getters

- (NSDateComponents *)twoDaysAgoComponents {
    if (!_twoDaysAgoComponents) {
        _twoDaysAgoComponents = [[NSDateComponents alloc] init];
        _twoDaysAgoComponents.day = -2;
    }
    
    return _twoDaysAgoComponents;
}

- (NSDateComponents *)previousDayComponents {
    if (!_previousDayComponents) {
        _previousDayComponents = [[NSDateComponents alloc] init];
        _previousDayComponents.day = -1;
    }
    
    return _previousDayComponents;
}

- (NSDateComponents *)nextComponents {
    if (!_nextComponents) {
        _nextComponents = [[NSDateComponents alloc] init];
        _nextComponents.day = 1;
    }
    
    return _nextComponents;
}

- (NSDateComponents *)twoDaysLaterComponents {
    if (!_twoDaysLaterComponents) {
        _twoDaysLaterComponents = [[NSDateComponents alloc] init];
        _twoDaysLaterComponents.day = 2;
    }
    
    return _twoDaysLaterComponents;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    MCCEventsTableViewController *currentEventsTableViewController = (MCCEventsTableViewController *)viewController;
    
    NSDate *previousDate = [[NSCalendar currentCalendar] dateByAddingComponents:self.previousDayComponents
                                                                         toDate:currentEventsTableViewController.date
                                                                        options:0];
    NSDate *twoDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:self.twoDaysAgoComponents
                                                                       toDate:[NSDate date]
                                                                      options:0];
    
    MCCEventsTableViewController *previousEventsTableViewController;
    
    if ([twoDaysAgo compare:previousDate] == NSOrderedAscending) {
        previousEventsTableViewController = [[MCCEventsTableViewController alloc] init];
        previousEventsTableViewController.date = previousDate;
        previousEventsTableViewController.pageNumber = currentEventsTableViewController.pageNumber - 1;
    }
    
    return previousEventsTableViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    MCCEventsTableViewController *currentEventsTableViewController = (MCCEventsTableViewController *)viewController;
    
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:self.nextComponents
                                                                     toDate:currentEventsTableViewController.date
                                                                    options:0];
    NSDate *tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:self.nextComponents
                                                                         toDate:[NSDate date]
                                                                        options:0];
    
    MCCEventsTableViewController *nextEventsTableViewController;
    
    if ([tomorrow compare:nextDate] == NSOrderedDescending) {
        nextEventsTableViewController = [[MCCEventsTableViewController alloc] init];
        nextEventsTableViewController.date = nextDate;
        nextEventsTableViewController.pageNumber = currentEventsTableViewController.pageNumber + 1;
    }
    
    return nextEventsTableViewController;
}

@end

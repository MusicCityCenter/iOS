//
//  MCCPageViewControllerDelegate.m
//  Music City Center
//
//  Created by Seth Friedman on 4/15/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCPageViewControllerDelegate.h"
#import "MCCEventsTableViewController.h"

@interface MCCPageViewControllerDelegate ()

@property (weak, nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation MCCPageViewControllerDelegate

#pragma mark - Designated Initializer

- (instancetype)initWithSegmentedControl:(UISegmentedControl *)segmentedControl {
    self = [super init];
    
    if (self) {
        _segmentedControl = segmentedControl;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)pageViewControllerDelegateWithSegmentedControl:(UISegmentedControl *)segmentedControl {
    return [[self alloc] initWithSegmentedControl:segmentedControl];
}

#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        MCCEventsTableViewController *currentViewController = [pageViewController.viewControllers firstObject];
        
        self.segmentedControl.selectedSegmentIndex = currentViewController.pageNumber;
    }
}

@end

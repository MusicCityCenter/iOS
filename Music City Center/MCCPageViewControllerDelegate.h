//
//  MCCPageViewControllerDelegate.h
//  Music City Center
//
//  Created by Seth Friedman on 4/15/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCPageViewControllerDelegate : NSObject <UIPageViewControllerDelegate>

/**
 *  Designated Initializer
 *
 *  @param segmentedControl The segmented control to update when the page has changed
 *
 *  @return The instantiated delegate
 */
- (instancetype)initWithSegmentedControl:(UISegmentedControl *)segmentedControl;

/**
 *  Factory Method
 *
 *  @param segmentedControl The segmented control to update when the page has changed
 *
 *  @return Delegate instance
 */
+ (instancetype)pageViewControllerDelegateWithSegmentedControl:(UISegmentedControl *)segmentedControl;

@end

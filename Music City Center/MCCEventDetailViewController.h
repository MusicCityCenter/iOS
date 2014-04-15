//
//  MCCEventDetailViewController.h
//  Music City Center
//
//  Created by Seth Friedman on 4/15/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCEvent;

@interface MCCEventDetailViewController : UIViewController

@property (nonatomic, strong) NSString *tweet;
@property (strong, nonatomic) MCCEvent *event;

@end

//
//  MCCEventDetailViewController.h
//  Music City Center
//
//  Created by Seth Friedman on 4/15/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCEvent.h"

@interface MCCEventDetailViewController : UIViewController

@property (nonatomic, strong) NSString *tweet;
@property (strong, nonatomic) MCCEvent *event1;

@end

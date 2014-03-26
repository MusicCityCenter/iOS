//
//  MCCEventDetailViewController.h
//  Music City Center
//
//  Created by Marissa Montgomery on 3/25/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCCEvent.h"

@interface MCCEventDetailViewController : UIViewController

@property (nonatomic, strong) NSString *tweet;
- (void)setEvent:(MCCEvent *)event;

@end

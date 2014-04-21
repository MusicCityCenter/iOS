//
//  MCCEventsTableViewController.h
//  Music City Center
//
//  Created by Seth Friedman on 3/31/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCEventsTableViewController : UITableViewController

@property (strong, nonatomic) NSDate *date;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic) NSInteger lowerHour;
@property (nonatomic) NSInteger lowerMinute;
@property (nonatomic) NSInteger upperHour;
@property (nonatomic) NSInteger upperMinute;

@end

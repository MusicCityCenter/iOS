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
@property (strong, nonatomic) MCCEvent *event1;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


- (void)setEvent:(MCCEvent *)event0;

@end

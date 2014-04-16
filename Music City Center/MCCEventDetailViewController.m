//
//  MCCEventDetailViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 4/15/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEventDetailViewController.h"
#import "MCCEvent.h"
#import "MCCFloorPlanLocation.h"
#import "MCCFloorViewController.h"

@interface MCCEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MCCEventDetailViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.event) {
        self.titleLabel.text = self.event.name;
        //self.descriptionLabel.text = self.event1.details;
        self.timeLabel.text = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)self.event.month, (long)self.event.day, (long)self.event.year];
        self.roomLabel.text = self.event.locationId;
        self.descriptionLabel.text = self.event.details;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EventDetailRoute"]) {
        if ([sender isKindOfClass:[MCCEvent class]]) {
            MCCEvent *event = (MCCEvent *)sender;
            
            MCCFloorViewController *floorViewController = segue.destinationViewController;
            [floorViewController setPolylineFromEvent:event];
        }
    }
}

@end

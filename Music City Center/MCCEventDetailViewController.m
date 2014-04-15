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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.event1.name;
    //self.descriptionLabel.text = self.event1.details;
    self.timeLabel.text = [NSString stringWithFormat:@"%d/%d/%d", event1.month, event1.day, event1.year];
    self.roomLabel.text = event1.locationId;
    
    //[self.labelOutlet setText:self.tweet];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EventDetailRoute"]) {
        if ([sender isKindOfClass:[MCCEvent class]]) {
            MCCEvent *event = (MCCEvent *) sender;
            
            MCCFloorViewController *floorViewController = segue.destinationViewController;
            [floorViewController setPolylineFromEvent:event];
        }
    }
}

@end

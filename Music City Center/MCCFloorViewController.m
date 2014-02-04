//
//  MCCFloorViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorViewController.h"

@interface MCCFloorViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mapImage;

@end

@implementation MCCFloorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.title = @"test";
}

@end

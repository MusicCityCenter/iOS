//
//  MCCFloorViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorViewController.h"
#import <MBXMapKit/MBXMapKit.h>

@interface MCCFloorViewController ()

@property (weak, nonatomic) IBOutlet MBXMapView *mapView;

@end

@implementation MCCFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.mapView.mapID = @"musiccitycenter.du2z9f6r";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

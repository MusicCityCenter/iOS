//
//  MCCSettingsTableViewController.m
//  Music City Center
//
//  Created by Seth Friedman on 3/18/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCSettingsTableViewController.h"

NSString * const MCCSettingsAvoidStairsKey = @"AvoidStairs";
NSString * const MCCSettingsHideArtKey = @"HideArt";

@interface MCCSettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *avoidStairsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hideArtSwitch;

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation MCCSettingsTableViewController

#pragma mark - Custom Getter

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avoidStairsSwitch.on = [self.userDefaults boolForKey:MCCSettingsAvoidStairsKey];
    self.hideArtSwitch.on = [self.userDefaults boolForKey:MCCSettingsHideArtKey];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.userDefaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB Actions

- (IBAction)avoidStairsSwitched:(UISwitch *)sender {
    [self.userDefaults setBool:sender.on
                        forKey:MCCSettingsAvoidStairsKey];
}

- (IBAction)hideArtSwitched:(UISwitch *)sender {
    [self.userDefaults setBool:sender.on
                        forKey:MCCSettingsHideArtKey];
}

@end

//
//  MCCAppDelegate.h
//  Music City Center
//
//  Created by Clark Perkins on 2/3/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCNavData;

@interface MCCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MCCNavData *navData;

@end

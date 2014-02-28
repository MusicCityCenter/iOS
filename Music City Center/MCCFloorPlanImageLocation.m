//
//  MCCFloorplanImageLocation.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlanImageLocation.h"

@implementation MCCFloorPlanImageLocation

#pragma mark - Designated Initializer

- (instancetype)initWithX:(NSInteger)x andY:(NSInteger)y {
    self = [super init];
    
    if (self) {
        _x = x;
        _y = y;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorPlanImageLocationWithX:(NSInteger)x andY:(NSInteger)y {
    return [[self alloc] initWithX:x
                              andY:y];
}

@end

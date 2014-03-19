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

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && (self == object || [self isEqualToFloorPlanImageLocation:object]);
}

- (NSUInteger)hash {
    return self.x ^ self.y;
}

#pragma mark - Helper Method

- (BOOL)isEqualToFloorPlanImageLocation:(MCCFloorPlanImageLocation *)floorPlanImageLocation {
    return self.x == floorPlanImageLocation.x && self.y == floorPlanImageLocation.y;
}

@end

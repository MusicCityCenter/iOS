//
//  MCCNavData.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCNavData.h"

@implementation MCCNavData

#pragma mark - Designated Initializer

- (instancetype)initWithFloorPlan:(MCCFloorPlan *)floorPlan andFloorPlanImageMapping:(MCCFloorPlanImageMapping *)mapping {
    self = [super init];
    
    if (self) {
        _floorPlan = floorPlan;
        _mapping = mapping;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)navDataWithFloorPlan:(MCCFloorPlan *)floorPlan andFloorPlanImageMapping:(MCCFloorPlanImageMapping *)mapping {
    return [[self alloc] initWithFloorPlan:floorPlan
                  andFloorPlanImageMapping:mapping];
}

@end

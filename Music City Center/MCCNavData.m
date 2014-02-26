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

- (instancetype)initWithFloorplan:(MCCFloorplan *)floorplan andFloorplanImageMapping:(MCCFloorplanImageMapping *)mapping {
    self = [super init];
    
    if (self) {
        _floorplan = floorplan;
        _mapping = mapping;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)navDataWithFloorplan:(MCCFloorplan *)floorplan andFloorplanImageMapping:(MCCFloorplanImageMapping *)mapping {
    return [[self alloc] initWithFloorplan:floorplan
                  andFloorplanImageMapping:mapping];
}

@end

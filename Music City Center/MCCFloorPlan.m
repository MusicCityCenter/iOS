//
//  MCCFloorplan.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlan.h"

@implementation MCCFloorPlan

#pragma mark - Designated Initializer

- (instancetype)initWithFloorPlanId:(NSString *)floorPlanId locations:(NSArray *)locations andEdges:(NSArray *)edges {
    self = [super init];
    
    if (self) {
        _floorPlanId = floorPlanId;
        _locations = locations;
        _edges = edges;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorplanWithFloorplanId:(NSString *)floorPlanId locations:(NSArray *)locations andEdges:(NSArray *)edges {
    return [[self alloc] initWithFloorPlanId:floorPlanId
                                   locations:locations
                                    andEdges:edges];
}

@end

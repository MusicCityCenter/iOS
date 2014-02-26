//
//  MCCFloorplan.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorplan.h"

@implementation MCCFloorplan

#pragma mark - Designated Initializer

- (instancetype)initWithFloorplanId:(NSString *)floorplanId locations:(NSArray *)locations andEdges:(NSArray *)edges {
    self = [super init];
    
    if (self) {
        _floorplanId = floorplanId;
        _locations = locations;
        _edges = edges;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorplanWithFloorplanId:(NSString *)floorplanId locations:(NSArray *)locations andEdges:(NSArray *)edges {
    return [[self alloc] initWithFloorplanId:floorplanId
                                   locations:locations
                                    andEdges:edges];
}

@end

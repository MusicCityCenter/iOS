//
//  MCCFloorplan.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorPlan : NSObject

@property (nonatomic, copy) NSString *floorPlanId;
@property (nonatomic, copy) NSArray *locations;
@property (nonatomic, copy) NSArray *edges;

- (instancetype)initWithFloorPlanId:(NSString *)floorPlanId locations:(NSArray *)locations andEdges:(NSArray *)edges;

+ (instancetype)floorPlanWithFloorplanId:(NSString *)floorPlanId locations:(NSArray *)locations andEdges:(NSArray *)edges;

@end

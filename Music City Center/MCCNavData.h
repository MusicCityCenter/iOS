//
//  MCCNavData.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorPlan;
@class MCCFloorPlanImageMapping;

@interface MCCNavData : NSObject

@property (strong, nonatomic) MCCFloorPlan *floorPlan;
@property (strong, nonatomic) MCCFloorPlanImageMapping *mapping;

- (instancetype)initWithFloorPlan:(MCCFloorPlan *)floorPlan andFloorPlanImageMapping:(MCCFloorPlanImageMapping *)mapping;

+ (instancetype)navDataWithFloorPlan:(MCCFloorPlan *)floorplan andFloorPlanImageMapping:(MCCFloorPlanImageMapping *)mapping;

@end

//
//  MCCFloorplanEdge.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorPlanLocation;

@interface MCCFloorPlanEdge : NSObject

@property (strong, nonatomic) MCCFloorPlanLocation *startLocation;
@property (strong, nonatomic) MCCFloorPlanLocation *endLocation;
@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat angle;

- (instancetype)initWithStartLocation:(MCCFloorPlanLocation *)startLocation endLocation:(MCCFloorPlanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle;

+ (instancetype)floorPlanEdgeWithStartLocation:(MCCFloorPlanLocation *)startLocation endLocation:(MCCFloorPlanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle;

@end

//
//  MCCFloorplanEdge.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorplanLocation;

@interface MCCFloorplanEdge : NSObject

@property (strong, nonatomic) MCCFloorplanLocation *startLocation;
@property (strong, nonatomic) MCCFloorplanLocation *endLocation;
@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat angle;

- (instancetype)initWithStartLocation:(MCCFloorplanLocation *)startLocation endLocation:(MCCFloorplanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle;

+ (instancetype)floorplanEdgeWithStartLocation:(MCCFloorplanLocation *)startLocation endLocation:(MCCFloorplanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle;

@end

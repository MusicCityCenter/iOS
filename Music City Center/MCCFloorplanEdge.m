//
//
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorplanEdge.h"

@implementation MCCFloorplanEdge

#pragma mark - Designated Initializer

- (instancetype)initWithStartLocation:(MCCFloorplanLocation *)startLocation endLocation:(MCCFloorplanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle {
    self = [super init];
    
    if (self) {
        _startLocation = startLocation;
        _endLocation = endLocation;
        _length = length;
        _angle = angle;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorplanEdgeWithStartLocation:(MCCFloorplanLocation *)startLocation endLocation:(MCCFloorplanLocation *)endLocation length:(CGFloat)length andAngle:(CGFloat)angle {
    return [[self alloc] initWithStartLocation:startLocation
                                   endLocation:endLocation
                                        length:length
                                      andAngle:angle];
}

@end

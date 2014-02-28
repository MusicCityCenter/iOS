//
//  MCCFloorPlanImage.m
//  Music City Center
//
//  Created by Clark Perkins on 2/26/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlanImage.h"
#import "MCCFloorPlanImageLocation.h"

@interface MCCFloorPlanImage ()

@property (nonatomic) CGFloat a;
@property (nonatomic) CGFloat b;
@property (nonatomic) CGFloat c;
@property (nonatomic) CGFloat d;
@property (nonatomic) CGFloat e;
@property (nonatomic) CGFloat f;

@end

@implementation MCCFloorPlanImage

- (instancetype)initWithSizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft {
    self = [super init];
    if (self) {
        _sizeX = sizeX;
        _sizeY = sizeY;
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomLeft = bottomLeft;
        
        // Set the offset
        _e = _topLeft.longitude;
        _f = _topLeft.latitude;
        
        // Translate so that (0,0) maps to (0,0)
        CLLocationCoordinate2D tempTopRight = CLLocationCoordinate2DMake(_topRight.latitude - _topLeft.latitude,
                                                                _topRight.longitude - _topLeft.longitude);
        CLLocationCoordinate2D tempBottomLeft = CLLocationCoordinate2DMake(_bottomLeft.latitude - _topLeft.latitude,
                                                                  _bottomLeft.longitude - _topLeft.longitude);
        // Calculate matrix
        _a = tempTopRight.longitude / _sizeX;
        _c = tempTopRight.latitude / _sizeX;
        _b = tempBottomLeft.longitude / _sizeY;
        _d = tempBottomLeft.latitude / _sizeY;
    }
    return self;
}

+ (instancetype)floorPlanImageWithSizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft {
    
    return [[self alloc] initWithSizeX:sizeX
                                 sizeY:sizeY
                               topLeft:topLeft
                              topRight:topRight
                         andBottomLeft:bottomLeft];
}



- (CLLocationCoordinate2D)coordinateFromFloorPlanImageLocation:(MCCFloorPlanImageLocation *)floorPlanImageLocation {
    
    CLLocationDegrees longitude = self.a * floorPlanImageLocation.x + self.b * floorPlanImageLocation.y + self.e;
    CLLocationDegrees latitude = self.c * floorPlanImageLocation.x + self.d * floorPlanImageLocation.y + self.f;
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

@end

//
//  MCCFloorPlanImage.m
//  Music City Center
//
//  Created by Clark Perkins on 2/26/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlanImage.h"
#import "MCCFloorplanImageLocation.h"

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
        CLLocationCoordinate2D tmpTopRight = CLLocationCoordinate2DMake(_topRight.latitude - _topLeft.latitude,
                                                                _topRight.longitude - _topLeft.longitude);
        CLLocationCoordinate2D tmpBottomLeft = CLLocationCoordinate2DMake(_bottomLeft.latitude - _topLeft.latitude,
                                                                  _bottomLeft.longitude - _topLeft.longitude);
        // Calculate matrix
        _a = tmpTopRight.longitude / _sizeX;
        _c = tmpTopRight.latitude / _sizeX;
        _b = tmpBottomLeft.longitude / _sizeY;
        _d = tmpBottomLeft.latitude / _sizeY;
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



- (CLLocationCoordinate2D)coordinateFromFloorplanImageLocation:(MCCFloorplanImageLocation *)floorplanImageLocation {
    
    CLLocationDegrees longitude = self.a * floorplanImageLocation.x + self.b * floorplanImageLocation.y + self.e;
    CLLocationDegrees latitude = self.c * floorplanImageLocation.x + self.d * floorplanImageLocation.y + self.f;
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

@end

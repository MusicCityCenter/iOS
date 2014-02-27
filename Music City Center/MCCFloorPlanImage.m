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

@property (nonatomic) double a;
@property (nonatomic) double b;
@property (nonatomic) double c;
@property (nonatomic) double d;
@property (nonatomic) double e;
@property (nonatomic) double f;

@end

@implementation MCCFloorPlanImage

+ (instancetype)floorPlanImageWithsizeX:(NSInteger)x sizeY:(NSInteger)y andCoordinatesAtTopLeft:(CLLocationCoordinate2D)tl topRight:(CLLocationCoordinate2D)tr bottomLeft:(CLLocationCoordinate2D)bl {
    MCCFloorPlanImage *_ret = [[MCCFloorPlanImage alloc] init];
    if (_ret) {
        _ret.sizeX = x;
        _ret.sizeY = y;
        _ret.topLeft = tl;
        _ret.topRight = tr;
        _ret.bottomLeft = bl;
        _ret.e = _ret.topLeft.longitude;
        _ret.f = _ret.topLeft.latitude;
        
        CLLocationCoordinate2D tmptr = CLLocationCoordinate2DMake(_ret.topRight.latitude - _ret.topLeft.latitude,
                                                                _ret.topRight.longitude - _ret.topLeft.longitude);
        CLLocationCoordinate2D tmpbl = CLLocationCoordinate2DMake(_ret.bottomLeft.latitude - _ret.topLeft.latitude,
                                                                  _ret.bottomLeft.longitude - _ret.topLeft.longitude);
        
        _ret.a = tmptr.longitude / _ret.sizeX;
        _ret.c = tmptr.latitude / _ret.sizeX;
        _ret.b = tmpbl.longitude / _ret.sizeY;
        _ret.d = tmpbl.latitude / _ret.sizeY;
    }
    return _ret;
}

-(CLLocationCoordinate2D)getLatLongFromLocation:(MCCFloorplanImageLocation *)loc {
    
    CLLocationDegrees lon = self.a * loc.x + self.b * loc.y + self.e;
    CLLocationDegrees lat = self.c * loc.x + self.d * loc.y + self.f;
    
    return CLLocationCoordinate2DMake(lat, lon);
}

@end

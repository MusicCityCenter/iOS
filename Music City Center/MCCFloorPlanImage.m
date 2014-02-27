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

+ (instancetype)floorPlanImageWithsizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft {
    
    return [[self alloc] initWithsizeX:sizeX
                                 sizeY:sizeY
                               topLeft:topLeft
                              topRight:topRight
                         andBottomLeft:bottomLeft];
}

- (instancetype)initWithsizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft {
    self = [super init];
    if (self) {
        _sizeX = sizeX;
        _sizeY = sizeY;
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomLeft = bottomLeft;
        
        // Set the offset
        _e = self.topLeft.longitude;
        _f = self.topLeft.latitude;
        
        // Translate so that (0,0) maps to (0,0)
        CLLocationCoordinate2D tmptr = CLLocationCoordinate2DMake(self.topRight.latitude - self.topLeft.latitude,
                                                                self.topRight.longitude - self.topLeft.longitude);
        CLLocationCoordinate2D tmpbl = CLLocationCoordinate2DMake(self.bottomLeft.latitude - self.topLeft.latitude,
                                                                  self.bottomLeft.longitude - self.topLeft.longitude);
        // Calculate matrix
        _a = tmptr.longitude / self.sizeX;
        _c = tmptr.latitude / self.sizeX;
        _b = tmpbl.longitude / self.sizeY;
        _d = tmpbl.latitude / self.sizeY;
    }
    return self;
}

-(CLLocationCoordinate2D)getLatLongFromLocation:(MCCFloorplanImageLocation *)loc {
    
    CLLocationDegrees lon = self.a * loc.x + self.b * loc.y + self.e;
    CLLocationDegrees lat = self.c * loc.x + self.d * loc.y + self.f;
    
    return CLLocationCoordinate2DMake(lat, lon);
}

@end

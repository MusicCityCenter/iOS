//
//  MCCFloorPlanImage.h
//  Music City Center
//
//  Created by Clark Perkins on 2/26/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCFloorplanImageLocation.h"

@import CoreLocation;

@interface MCCFloorPlanImage : NSObject

@property (nonatomic) NSInteger sizeX;
@property (nonatomic) NSInteger sizeY;

@property (nonatomic) CLLocationCoordinate2D topLeft;
@property (nonatomic) CLLocationCoordinate2D topRight;
@property (nonatomic) CLLocationCoordinate2D bottomLeft;


- (instancetype)initWithsizeX:(NSInteger)x sizeY:(NSInteger)y topLeft:(CLLocationCoordinate2D)tl topRight:(CLLocationCoordinate2D)tr bottomLeft:(CLLocationCoordinate2D)bl;

- (CLLocationCoordinate2D)getLatLongFromLocation:(MCCFloorplanImageLocation *)loc;

@end

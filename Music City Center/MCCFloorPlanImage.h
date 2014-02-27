//
//  MCCFloorPlanImage.h
//  Music City Center
//
//  Created by Clark Perkins on 2/26/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

@import CoreLocation;

@class MCCFloorplanImageLocation;

@interface MCCFloorPlanImage : NSObject

@property (nonatomic) NSInteger sizeX;
@property (nonatomic) NSInteger sizeY;

@property (nonatomic) CLLocationCoordinate2D topLeft;
@property (nonatomic) CLLocationCoordinate2D topRight;
@property (nonatomic) CLLocationCoordinate2D bottomLeft;


- (instancetype)initWithsizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft;

+ (instancetype)floorPlanImageWithsizeX:(NSInteger)sizeX sizeY:(NSInteger)sizeY topLeft:(CLLocationCoordinate2D)topLeft topRight:(CLLocationCoordinate2D)topRight andBottomLeft:(CLLocationCoordinate2D)bottomLeft;

- (CLLocationCoordinate2D)getLatLongFromLocation:(MCCFloorplanImageLocation *)loc;

@end

//
//  MCCFloorplanLocation.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorplanLocation.h"

@implementation MCCFloorplanLocation

#pragma mark - Designated Initializer

- (instancetype)initWithLocationId:(NSString *)locationId andType:(NSString *)type {
    self = [super init];
    
    if (self) {
        _locationId = locationId;
        _type = type;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorplanLocationWithLocationId:(NSString *)locationId andType:(NSString *)type {
    return [[self alloc] initWithLocationId:locationId
                                    andType:type];
}

@end

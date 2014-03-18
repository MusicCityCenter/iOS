//
//  MCCFloorplanImageMapping.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlanImageMapping.h"

@implementation MCCFloorPlanImageMapping

#pragma mark - Designated Initializer

- (instancetype)initWithImageURL:(NSURL *)imageURL andMappingDictionary:(NSDictionary *)mappingDictionary {
    self = [super init];
    
    if (self) {
        _imageURL = imageURL;
        _mappingDictionary = mappingDictionary;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorPlanImageMappingWithImageURL:(NSURL *)imageURL andMappingDictionary:(NSDictionary *)mappingDictionary {
    return [[self alloc] initWithImageURL:imageURL andMappingDictionary:mappingDictionary];
}

#pragma mark - Instance Methods

- (MCCFloorPlanImageLocation *)coordinatesOfLocation:(NSString *)locationId {
    return self.mappingDictionary[locationId];
}

@end

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

- (instancetype)initWithImageURL:(NSURL *)imageURL {
    self = [super init];
    
    if (self) {
        _imageURL = imageURL;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorPlanImageMappingWithImageURL:(NSURL *)imageURL {
    return [[self alloc] initWithImageURL:imageURL];
}

#pragma mark - Instance Methods

@end

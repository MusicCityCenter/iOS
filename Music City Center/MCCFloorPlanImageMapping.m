//
//  MCCFloorplanImageMapping.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorPlanImageMapping.h"
#import "MCCClient.h"

@implementation MCCFloorPlanImageMapping

#pragma mark - Designated Initializer

- (instancetype)initWithFloorPlanID:(NSString *)floorPlanID {
    self = [super init];
    
    if (self) {
        _floorPlanID = floorPlanID;
        MCCClient *client = [MCCClient sharedClient];
        
        [client fetchFloorPlan:_floorPlanID withCompletionBlock:^(MCCNavData *navData) {
            
        }];
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)floorPlanImageMappingWithFloorPlanID:(NSString *)floorPlanID {
    return [[self alloc] initWithFloorPlanID:floorPlanID];
}

#pragma mark - Instance Methods

- (MCCFloorPlanImageLocation *)coordinatesOfLocation:(NSString *)locationId {
    return nil;
}

@end

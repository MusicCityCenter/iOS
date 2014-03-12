//
//  MCCFloorplanImageMapping.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorPlanLocation;
@class MCCFloorPlanImageLocation;

@interface MCCFloorPlanImageMapping : NSObject

@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSDictionary *mappingDictionary;

- (instancetype)initWithImageURL:(NSURL *)imageURL andMappingDictionary:(NSDictionary *)mappingDictionary;

+ (instancetype)floorPlanImageMappingWithImageURL:(NSURL *)imageURL andMappingDictionary:(NSDictionary *)mappingDictionary;

- (MCCFloorPlanImageLocation *)coordinatesOfLocation:(NSString *)locationId;

@end

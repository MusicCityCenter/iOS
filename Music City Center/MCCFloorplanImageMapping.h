//
//  MCCFloorplanImageMapping.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorplanLocation;
@class MCCFloorplanImageLocation;

@interface MCCFloorplanImageMapping : NSObject

@property (strong, nonatomic) NSURL *imageURL;

- (instancetype)initWithImageURL:(NSURL *)imageURL;

+ (instancetype)floorplanImageMappingWithImageURL:(NSURL *)imageURL;

- (MCCFloorplanImageLocation *)coordinatesOfLocation:(NSString *)locationId;

@end

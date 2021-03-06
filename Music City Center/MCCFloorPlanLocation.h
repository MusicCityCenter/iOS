//
//  MCCFloorplanLocation.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorPlanLocation : NSObject

@property (nonatomic, copy) NSString *locationId;
@property (nonatomic, copy) NSString *type;

- (instancetype)initWithLocationId:(NSString *)locationId andType:(NSString *)type;

+ (instancetype)floorPlanLocationWithLocationId:(NSString *)locationId andType:(NSString *)type;

@end

//
//  MCCFloorplanImageLocation.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorPlanImageLocation : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

- (instancetype)initWithX:(NSInteger)x andY:(NSInteger)y;

+ (instancetype)floorPlanImageLocationWithX:(NSInteger)x andY:(NSInteger)y;

@end

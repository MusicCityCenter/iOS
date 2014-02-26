//
//  MCCFloorplanImageLocation.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorplanImageLocation : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

- (instancetype)initWithX:(NSInteger)x andY:(NSInteger)y;

+ (instancetype)floorplanImageLocationWithX:(NSInteger)x andY:(NSInteger)y;

@end

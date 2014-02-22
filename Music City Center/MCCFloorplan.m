//
//  MCCFloorplan.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorplan.h"

@implementation MCCFloorplan

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locations = [NSArray array];
        _edges = [NSArray array];
    }
    
    return self;
}

@end

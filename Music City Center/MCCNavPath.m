//
//  MCCNavPath.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCNavPath.h"

@implementation MCCNavPath

#pragma mark - Designated Initializer

- (instancetype)initWithEdges:(NSArray *)edges {
    self = [super init];
    
    if (self) {
        _edges = edges;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)navPathWithEdges:(NSArray *)edges {
    return [[self alloc] initWithEdges:edges];
}

@end

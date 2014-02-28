//
//  MCCNavPath.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCNavPath : NSObject

@property (nonatomic, copy) NSArray *edges;

- (instancetype)initWithEdges:(NSArray *)edges;

+ (instancetype)navPathWithEdges:(NSArray *)edges;

@end

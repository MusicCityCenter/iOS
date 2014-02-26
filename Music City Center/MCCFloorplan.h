//
//  MCCFloorplan.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorplan : NSObject

@property (nonatomic, copy) NSString *floorplanId;
@property (nonatomic, copy) NSArray *locations;
@property (nonatomic, copy) NSArray *edges;

- (instancetype)initWithFloorplanId:(NSString *)floorplanId locations:(NSArray *)locations andEdges:(NSArray *)edges;

+ (instancetype)floorplanWithFloorplanId:(NSString *)floorplanId locations:(NSArray *)locations andEdges:(NSArray *)edges;

@end

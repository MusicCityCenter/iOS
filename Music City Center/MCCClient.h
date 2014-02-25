//
//  MCCNav.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class MCCNavData;
@class MCCNavPath;

@interface MCCClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)fetchFloorplan:(NSString *)floorplanId withCompletionBlock:(void (^)(MCCNavData *navData))completionBlock;
- (void)shortestPathOnFloorplan:(NSString *)floorplanId from:(NSString *)from to:(NSString *)endLocationId withCompletionBlock:(void (^)(MCCNavPath *path))completionBlock;
- (void)events:(NSString *)floorplanId on:(NSDate *)date withCompletionBlock:(void (^)(NSArray *events))completionBlock;

@end

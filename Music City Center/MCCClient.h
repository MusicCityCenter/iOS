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
@class MCCFloorPlanLocation;

@interface MCCClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)fetchFloorPlan:(NSString *)floorPlanId withCompletionBlock:(void (^)(MCCNavData *navData))completionBlock;
- (NSURLSessionDataTask *)shortestPathOnFloorPlan:(NSString *)floorPlanId from:(NSString *)from to:(NSString *)endLocationId withCompletionBlock:(void (^)(MCCNavPath *path))completionBlock;
- (NSURLSessionDataTask *)events:(NSString *)floorPlanId on:(NSDate *)date withCompletionBlock:(void (^)(NSArray *events))completionBlock;
-(NSURLSessionDataTask *)locationFromiBeacons:(NSDictionary *)beaconData floorPlan:(NSString *)floorPlanId withCompletionBlock:(void (^)(MCCFloorPlanLocation *))completionBlock;

@end

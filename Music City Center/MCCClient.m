//
//  MCCNav.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCClient.h"
#import "MCCResponseSerializer.h"

// Work Item 7
@implementation MCCClient

+ (instancetype)sharedClient {
    static MCCClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://0-1-dot-mcc-backend.appspot.com/mcc/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        config.URLCache = cache;
        
        _sharedClient = [[MCCClient alloc] initWithBaseURL:baseURL
                                      sessionConfiguration:config];
        _sharedClient.responseSerializer = [MCCResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)fetchFloorPlan:(NSString *)floorPlanId withCompletionBlock:(void (^)(MCCNavData *))completionBlock {
    // format: /mcc/floorplan/mapping/{floorplanId}
    NSLog(@"fetch floorplan");
    NSString *targetUrl = [NSString stringWithFormat:@"floorplan/mapping/%@", floorPlanId];
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Success
                                           NSLog(@"Floorplan fetched");
                                           completionBlock(responseObject);
                                           // responseObject should already be an MCCNavData object here thanks to MCCResponseSerializer
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Failure
                                           [[[UIAlertView alloc] initWithTitle:@"Error Retrieving the Floorplan"
                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                           
                                       }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)shortestPathOnFloorPlan:(NSString *)floorPlanId from:(NSString *)from to:(NSString *)endLocationId withCompletionBlock:(void (^)(MCCNavPath *))completionBlock {
    NSLog(@"shortest path");
    // format: /mcc/path/{floorplanId}/{startLocationId}/{endLocationId}
    NSString *targetUrl = [NSString stringWithFormat:@"path/%@/%@/%@", floorPlanId, from, endLocationId];
    
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Success
                                           NSLog(@"Shortest Path On Floorplan fetched");
                                           completionBlock(responseObject);
                                           // responseObject should already be an MCCNavPath object here thanks to MCCResponseSerializer
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Failure
                                           [[[UIAlertView alloc] initWithTitle:@"Error Finding the Shortest Path on the Floorplan"
                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                           
                                       }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)events:(NSString *)floorPlanId on:(NSDate *)date withCompletionBlock:(void (^)(NSArray *))completionBlock {
    NSLog(@"events for floorPlanId on date");
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                   fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    // format: /events/{floorplanId}/on/{month}/{day}/{year}
    NSString *targetUrl = [NSString stringWithFormat:@"events/%@/on/%li/%li/%li", floorPlanId, (long)month, (long)day, (long)year];
    
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Success
                                           NSLog(@"Events fetched");
                                           completionBlock(responseObject);
                                           // responseObject should already be an NSArray here thanks to MCCResponseSerializer
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                           NSLog(@"Received HTTP %d", httpResponse.statusCode);
                                           // Failure
                                           [[[UIAlertView alloc] initWithTitle:@"Error Finding the Shortest Path on the Floorplan"
                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                           
                                       }];
    
    return dataTask;
}

@end

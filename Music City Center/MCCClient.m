//
//  MCCNav.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCClient.h"

// Work Item 7
@implementation MCCClient

+ (instancetype)sharedClient {
    static MCCClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"http://www.nashvillemusiccitycenter.com/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        config.URLCache = cache;
        
        _sharedClient = [[MCCClient alloc] initWithBaseURL:baseURL
                                      sessionConfiguration:config];
        //_sharedClient.responseSerializer = [NOTResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (void)fetchFloorplan:(NSString *)floorplanId withCompletionBlock:(void (^)(MCCNavData *))completionBlock {
    // format: /mcc/floorplan/mapping/{floorplanId}
    NSString *targetUrl = [NSString stringWithFormat:@"floorplan/mapping/%@", floorplanId];
    
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           // Success
                                           
                                           // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
                                           // the data structures in MCCFloorplan, MCCFloorplanImageMapping, etc.
                                           // ...see: https://github.com/dchohfi/KeyValueObjectMapping
                                           //
                                           // Example Response:
                                           //{"mapping":{"imageUrl":"/mcc/image/floorplan/windsor","mapping":{"k":{"x":878,"y":556},"g":{"x":679,"y":541},"f":{"x":477,"y":524},"df":{"x":880,"y":359}}},"floorplan":{"locations":[{"id":"g","type":"room"},{"id":"df","type":"room"},{"id":"k","type":"room"},{"id":"f","type":"room"}],"edges":[{"start":"g","end":"k","length":0.0},{"start":"g","end":"f","length":0.0},{"start":"df","end":"k","length":0.0},{"start":"k","end":"g","length":0.0},{"start":"k","end":"df","length":0.0},{"start":"f","end":"g","length":0.0}],"types":{"name":"root","children":[{"name":"room"}]}}}
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           // Failure
                                       }];
}

- (void)shortestPathOnFloorplan:(NSString *)floorplanId from:(NSString *)from to:(NSString *)endLocationId withCompletionBlock:(void (^)(MCCNavPath *))completionBlock {
    // format: /mcc/path/{floorplanId}/{startLocationId}/{endLocationId}
    NSString *targetUrl = [NSString stringWithFormat:@"path/%@/%@/%@", floorplanId, from, endLocationId];
    
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           // Success
                                           
                                           // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
                                           // the data structures in MCCNavPath...see: https://github.com/dchohfi/KeyValueObjectMapping
                                           //
                                           // Example Response:
                                           // [{"from":"f","to":"g","length":202.71408436514716,"angle":355.18941380563433},{"from":"g","to":"k","length":199.56452590578317,"angle":355.68937417517947}]
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           // Failure
                                       }];
}

- (void)events:(NSString *)floorplanId on:(NSDate *)date withCompletionBlock:(void (^)(NSArray *))completionBlock {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                   fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    // format: /events/{floorplanId}/on/{month}/{day}/{year}
    NSString *targetUrl = [NSString stringWithFormat:@"events/%@/on/%li/%li/%li", floorplanId, (long)month, (long)day, (long)year];
    
    NSURLSessionDataTask *dataTask = [self GET:targetUrl
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           // Success
                                           
                                           // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
                                           // the data structures in MCCNavPath...see: https://github.com/dchohfi/KeyValueObjectMapping
                                           //
                                           // Example Response:
                                           // [{"id":"75cc1e2b-b26c-4668-83b1-99433f4d334f","name":"asdf","description":"asdf","day":5,"month":1,"year":2014,"startTime":420,"endTime":1380,"floorplanId":"windsor","floorplanLocationId":"g"}]
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           // Failure
                                       }];
}

@end

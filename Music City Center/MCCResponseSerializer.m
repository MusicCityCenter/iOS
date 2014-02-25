//
//  MCCResponseSerializer.m
//  Music City Center
//
//  Created by Seth Friedman on 2/24/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCResponseSerializer.h"

@implementation MCCResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id responseObject = [super responseObjectForResponse:response
                                                    data:data
                                                   error:error];
    
    // Hydrate the JSON in responseObject into actual objects like MCCFloorplan
    //
    // E.g. for an MCCFloorplan:
    //
    // NSArray *locationsJSONArray = responseObject[@"locations"];
    // NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[locationJSONArray count]];
    //
    // for (NSDictionary *locationJSONDictionary in locationsJSONArray) {
    //     [locations addObject:[MCCFloorplanLocation floorplanLocationWithLocationId:locationJSONDictionary[@"id"]
    //                                                                        andType:locationJSONDictionary[@"type"]]];
    // }
    
    // Create MCCFloorplan with locations, etc.
    
    // responseObject = floorplan;
    
    return responseObject;
}

@end

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
    
    // Example Floorplan Mapping Response:
    //{"mapping":{"imageUrl":"/mcc/image/floorplan/windsor","mapping":{"k":{"x":878,"y":556},"g":{"x":679,"y":541},"f":{"x":477,"y":524},"df":{"x":880,"y":359}}},"floorplan":{"locations":[{"id":"g","type":"room"},{"id":"df","type":"room"},{"id":"k","type":"room"},{"id":"f","type":"room"}],"edges":[{"start":"g","end":"k","length":0.0},{"start":"g","end":"f","length":0.0},{"start":"df","end":"k","length":0.0},{"start":"k","end":"g","length":0.0},{"start":"k","end":"df","length":0.0},{"start":"f","end":"g","length":0.0}],"types":{"name":"root","children":[{"name":"room"}]}}}
    
    // Example Path Response:
    // [{"from":"f","to":"g","length":202.71408436514716,"angle":355.18941380563433},{"from":"g","to":"k","length":199.56452590578317,"angle":355.68937417517947}]
    
    // Example Events Response:
    // [{"id":"75cc1e2b-b26c-4668-83b1-99433f4d334f","name":"asdf","description":"asdf","day":5,"month":1,"year":2014,"startTime":420,"endTime":1380,"floorplanId":"windsor","floorplanLocationId":"g"}]
    
    return responseObject;
}

@end

//
//  MCCResponseSerializer.m
//  Music City Center
//
//  Created by Seth Friedman on 2/24/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCResponseSerializer.h"
#import "MCCEvent.h"
#import "MCCNavPath.h"
#import "MCCNavData.h"
#import "MCCFloorPlan.h"
#import "MCCFloorPlanEdge.h"
#import "MCCFloorPlanLocation.h"
#import "MCCFloorPlanImageLocation.h"
#import "MCCFloorPlanImageMapping.h"

@implementation MCCResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id responseObject = [super responseObjectForResponse:response
                                                    data:data
                                                   error:error];
    
    // Hydrate the JSON in responseObject into actual objects like MCCFloorPlan
    //
    // E.g. for an MCCFloorPlan:
    //
    // NSArray *locationsJSONArray = responseObject[@"locations"];
    // NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[locationJSONArray count]];
    //
    // for (NSDictionary *locationJSONDictionary in locationsJSONArray) {
    //     [locations addObject:[MCCFloorPlanLocation floorPlanLocationWithLocationId:locationJSONDictionary[@"id"]
    //                                                                        andType:locationJSONDictionary[@"type"]]];
    // }
    
    // Create MCCFloorPlan with locations, etc.
    
    // responseObject = floorPlan;
    
    // Example FloorPlan Mapping Response:
    //{"mapping":{"imageUrl":"/mcc/image/floorplan/windsor","mapping":{"k":{"x":878,"y":556},"g":{"x":679,"y":541},"f":{"x":477,"y":524},"df":{"x":880,"y":359}}},"floorplan":{"locations":[{"id":"g","type":"room"},{"id":"df","type":"room"},{"id":"k","type":"room"},{"id":"f","type":"room"}],"edges":[{"start":"g","end":"k","length":0.0},{"start":"g","end":"f","length":0.0},{"start":"df","end":"k","length":0.0},{"start":"k","end":"g","length":0.0},{"start":"k","end":"df","length":0.0},{"start":"f","end":"g","length":0.0}],"types":{"name":"root","children":[{"name":"room"}]}}}
    
    // Example Path Response:
    // [{"from":"f","to":"g","length":202.71408436514716,"angle":355.18941380563433},{"from":"g","to":"k","length":199.56452590578317,"angle":355.68937417517947}]
    
    // Example Events Response:
    // [{"id":"75cc1e2b-b26c-4668-83b1-99433f4d334f","name":"asdf","description":"asdf","day":5,"month":1,"year":2014,"startTime":420,"endTime":1380,"floorplanId":"windsor","floorplanLocationId":"g"}]
    
    NSURL *relativeURL = [NSURL URLWithString:response.URL.relativePath];
    NSString *firstPathComponent = relativeURL.pathComponents[2];
    
    // TODO - Change the order of these checks to floorplan, then shortest path, then events - just for consistency - instead of
    // events first
    if ([firstPathComponent isEqualToString:@"floorplan"]) {
        NSLog(@"Turning response into MCCNavData");
        
        
        // Get the mapping
        NSMutableDictionary *mappingDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *locationID in responseObject[@"mapping"][@"mapping"]) {
            MCCFloorPlanImageLocation *location =
            [MCCFloorPlanImageLocation
             floorPlanImageLocationWithX:[responseObject[@"mapping"][@"mapping"][locationID][@"x"] integerValue]
             andY:[responseObject[@"mapping"][@"mapping"][locationID][@"y"] integerValue]];
            
            mappingDictionary[locationID] = location;
        }
        
        MCCFloorPlanImageMapping *floorPlanImageMapping =
        [MCCFloorPlanImageMapping
         floorPlanImageMappingWithImageURL:[NSURL URLWithString:responseObject[@"mapping"][@"imageUrl"]]
         andMappingDictionary:mappingDictionary];
        
        
        // Get all the locations
        NSMutableArray *locationArray = [NSMutableArray array];
        
        for (NSDictionary *locationDictionary in responseObject[@"floorplan"][@"locations"]) {
            MCCFloorPlanLocation *location = [MCCFloorPlanLocation
                                              floorPlanLocationWithLocationId:locationDictionary[@"id"]
                                              andType:locationDictionary[@"type"]];
            [locationArray addObject:location];
        }
        
        // Get all the edges
        NSMutableArray *edgeArray = [NSMutableArray array];
        
        for (NSDictionary *edgeDictionary in responseObject[@"floorplan"][@"edges"]) {
            MCCFloorPlanEdge *edge = [MCCFloorPlanEdge
                                      floorPlanEdgeWithStartLocation: [MCCFloorPlanLocation floorPlanLocationWithLocationId:edgeDictionary[@"start"] andType:@"unknown"]
                                      endLocation:[MCCFloorPlanLocation floorPlanLocationWithLocationId:edgeDictionary[@"end"] andType:@"unknown"]
                                      length:[edgeDictionary[@"length"] floatValue]
                                      andAngle:0];
            [edgeArray addObject:edge];
        }
        
        // Combine the locations and edges into a FloorPlan
        MCCFloorPlan *floorPlan = [MCCFloorPlan floorPlanWithFloorplanId:relativeURL.pathComponents[4] locations:locationArray andEdges:edgeArray];
        
        // Put it all together into a NavData object
        return [MCCNavData navDataWithFloorPlan:floorPlan andFloorPlanImageMapping:floorPlanImageMapping];
        
    } else if ([firstPathComponent isEqualToString:@"path"]) {
        NSLog(@"Turning response into MCCNavPath");
        
        NSMutableArray *edges = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *edgeDictionary in responseObject) {
            MCCFloorPlanLocation *startLocation = [MCCFloorPlanLocation
                                                   floorPlanLocationWithLocationId:edgeDictionary[@"from"]
                                                   andType:@"unknown"];
            
            MCCFloorPlanLocation *endLocation = [MCCFloorPlanLocation
                                                 floorPlanLocationWithLocationId:edgeDictionary[@"to"]
                                                 andType:@"unknown"];
            
            
            MCCFloorPlanEdge *edge = [MCCFloorPlanEdge
                                      floorPlanEdgeWithStartLocation:startLocation
                                      endLocation:endLocation
                                      length:[edgeDictionary[@"length"] floatValue]
                                      andAngle:[edgeDictionary[@"angle"] floatValue]];
            [edges addObject:edge];
        }
        
        return [MCCNavPath navPathWithEdges:edges];
        
    } else if ([firstPathComponent isEqualToString:@"events"]) {
        NSLog(@"Turning response into NSArray of MCCEvents");
        
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary *eventDictionary in responseObject) {
            MCCEvent *event = [MCCEvent eventWithMonth:[eventDictionary[@"month"] integerValue]
                                                   day:[eventDictionary[@"day"] integerValue]
                                                  year:[eventDictionary[@"year"] integerValue]
                                                  name:eventDictionary[@"name"]
                                            andDetails:eventDictionary[@"details"]];
            
            event.locationId = eventDictionary[@"floorplanLocationId"];
            [events addObject:event];
        }
        return events;
    }
    
    return responseObject;
}

@end

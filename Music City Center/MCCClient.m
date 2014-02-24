//
//  MCCNav.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCClient.h"
#import "NSString+URLEncode.h"

// Work Item 7
@implementation MCCClient

- (instancetype)initWithServer:(NSString *)host port:(NSInteger)port andBasePath:(NSString *)basePath {
    self = [super init];
    
    if (self) {
        _host = host;
        _port = port;
        
        // The base path of the web endpoints (e.g., "/mcc/" )
        _basePath = basePath;
    }
    
    return self;
}

- (void)loadFloorplan:(NSString *)floorplanId andInvoke:(id<MCCNavListener>)callback {
    // format: /mcc/floorplan/mapping/{floorplanId}
    NSString *targetUrl = [self.basePath stringByAppendingString:@"/floorplan/mapping/"];
    targetUrl = [targetUrl stringByAppendingString:[floorplanId urlencode]];
    
    // Send the HTTP request
    //...
    
    // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
    // the data structures in MCCFloorplan, MCCFloorplanImageMapping, etc.
    // ...see: https://github.com/dchohfi/KeyValueObjectMapping
    //
    // Example Response:
    //{"mapping":{"imageUrl":"/mcc/image/floorplan/windsor","mapping":{"k":{"x":878,"y":556},"g":{"x":679,"y":541},"f":{"x":477,"y":524},"df":{"x":880,"y":359}}},"floorplan":{"locations":[{"id":"g","type":"room"},{"id":"df","type":"room"},{"id":"k","type":"room"},{"id":"f","type":"room"}],"edges":[{"start":"g","end":"k","length":0.0},{"start":"g","end":"f","length":0.0},{"start":"df","end":"k","length":0.0},{"start":"k","end":"g","length":0.0},{"start":"k","end":"df","length":0.0},{"start":"f","end":"g","length":0.0}],"types":{"name":"root","children":[{"name":"room"}]}}}
    
}

- (void)shortestPath:(NSString *)floorplanId from:(NSString *)fromLocation to:(NSString *)toLocation {
    // format: /mcc/path/{floorplanId}/{startLocationId}/{endLocationId}
    NSString *targetUrl = [self.basePath stringByAppendingFormat:@"/path/%@/%@/%@",
                           [floorplanId urlencode],
                           [fromLocation urlencode],
                           [toLocation urlencode]
                           ];
    
    // Send the HTTP request
    //...
    
    // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
    // the data structures in MCCNavPath...see: https://github.com/dchohfi/KeyValueObjectMapping
    //
    // Example Response:
    // [{"from":"f","to":"g","length":202.71408436514716,"angle":355.18941380563433},{"from":"g","to":"k","length":199.56452590578317,"angle":355.68937417517947}]
}

- (void)events:(NSString *)floorplanId on:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
                                                                   fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    // format: /events/{floorplanId}/on/{month}/{day}/{year}
    NSString *targetUrl = [self.basePath stringByAppendingFormat:@"/events/%@/on/%li/%li/%li",
                           [floorplanId urlencode],
                           (long)month,
                           (long)day,
                           (long)year
                           ];
    
    // Send the HTTP request
    //...
    
    // Parse the JSON response and turn it into a MCCNavData object. The JSON should mirror
    // the data structures in MCCNavPath...see: https://github.com/dchohfi/KeyValueObjectMapping
    //
    // Example Response:
    // [{"id":"75cc1e2b-b26c-4668-83b1-99433f4d334f","name":"asdf","description":"asdf","day":5,"month":1,"year":2014,"startTime":420,"endTime":1380,"floorplanId":"windsor","floorplanLocationId":"g"}]
}

@end

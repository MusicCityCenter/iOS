//
//  MCCEvent.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCEvent.h"

@implementation MCCEvent

#pragma mark - Designated Initializer

- (instancetype)initWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year name:(NSString *)name details:(NSString *)details startTime:(NSInteger)startTime andEndTime:(NSInteger)endTime{
    self = [super init];
    
    if (self) {
        _month = month;
        _day = day;
        _year = year;
        _name = name;
        _details = details;
        _startTime = startTime;
        _endTime = endTime;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)eventWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year name:(NSString *)name details:(NSString *)details startTime:(NSInteger)startTime andEndTime:(NSInteger)endTime {
    return [[self alloc] initWithMonth:(NSInteger)month
                                   day:(NSInteger)day
                                  year:(NSInteger)year
                                  name:(NSString *)name
                               details:(NSString *)details
                             startTime:(NSInteger)startTime
                            andEndTime:(NSInteger)endTime];
}

@end

//
//  MCCEvent.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCEvent : NSObject

@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger year;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;

// An id of a MCCFloorplanLocation
@property (nonatomic, copy) NSString *locationId;

- (instancetype)initWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year name:(NSString *)name details:(NSString *)details startTime:(NSInteger)startTime andEndTime:(NSInteger)endTime;

+ (instancetype)eventWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year name:(NSString *)name details:(NSString *)details startTime:(NSInteger)startTime andEndTime:(NSInteger)endTime;

@end

//
//  MCCNav.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCNavListener.h"
#import "MCCEventListener.h"

@interface MCCNav : NSObject

@property (nonatomic, copy) NSString *host;
@property (nonatomic) NSInteger port;
@property (nonatomic, copy) NSString *basePath;

- (instancetype)initWithServer:(NSString *)host port:(NSInteger)port andBasePath:(NSString *)basePath;
- (void)loadFloorplan:(NSString *)floorplanId andInvoke:(id<MCCNavListener>)callback;
- (void)shortestPath:(NSString *)floorplanId from:(NSString *)from to:(NSString *)endLocationId andCall:(id<MCCNavListener>)listener;
- (void)events:(NSString *)floorplanId on:(NSDate *)date andCall:(id<MCCEventListener>)listener;

@end

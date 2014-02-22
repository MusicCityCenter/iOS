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
{
}

- (id)initWithServer:(NSString*)host andPort:(int)port andBasePath:(NSString*)basePath;
- (void)loadFloorplan:(NSString*)floorplanId andInvoke:(id<MCCNavListener>)callback;
- (void)getShortestPath:(NSString*)floorplanId from:(NSString*)from to:(NSString*)endLocationId andCall:(id<MCCNavListener>)listener;
- (void)getEvents:(NSString*)floorplanId on:(NSDate*)date andCall:(id<MCCEventListener>)listener;

@property(nonatomic,retain)NSString* host;
@property(nonatomic,retain)NSString* basePath;
@property(nonatomic)int port;

@end

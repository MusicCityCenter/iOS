//
//  MCCEventListener.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MCCEventListener <NSObject>

// Called by MCCNav and passed an NSArray of MCCEvent objects
// after a call to MCCNav getEvents
- (void)eventsLoaded:(NSArray *)events;

@end

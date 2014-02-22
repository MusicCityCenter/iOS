//
//  MCCNavListener.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCNavData.h"
#import "MCCNavPath.h"

@protocol MCCNavListener <NSObject>

// This method is used as a callback by the MCCNav class
// to asynchronously deliver floor info after it is
// obtained from the server.
- (void) navDataLoaded:(MCCNavData*)navData;

// Called by MCCNav when a path is found between the locations provided
// to getShortestPath
- (void) navPathFound:(MCCNavPath*) path;

@end

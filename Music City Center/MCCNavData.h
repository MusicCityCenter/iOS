//
//  MCCNavData.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCCFloorplan;
@class MCCFloorplanImageMapping;

@interface MCCNavData : NSObject

@property (strong, nonatomic) MCCFloorplan *floorplan;
@property (strong, nonatomic) MCCFloorplanImageMapping *mapping;

@end
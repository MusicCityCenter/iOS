//
//  MCCNavData.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MCCFloorplan.h"
#import "MCCFloorplanImageMapping.h"

@interface MCCNavData : NSObject
{
}

@property(nonatomic,retain)MCCFloorplan* floorplan;
@property(nonatomic,retain)MCCFloorplanImageMapping* mapping;

@end

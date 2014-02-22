//
//  MCCFloorplanImageMapping.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCFloorplanLocation.h"
#import "MCCFloorplanImageLocation.h"

@interface MCCFloorplanImageMapping : NSObject
{
}

- (MCCFloorplanImageLocation*)coordinatesOfLocation:(NSString*)locationId;

@property(nonatomic,retain)NSString* imageUrl;

@end

//
//  MCCFloorplanEdge.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCCFloorplanLocation.h"

@interface MCCFloorplanEdge : NSObject
{
}

@property(nonatomic,retain)MCCFloorplanLocation* start;
@property(nonatomic,retain)MCCFloorplanLocation* end;
@property(nonatomic)double length;
@property(nonatomic)double angle;

@end

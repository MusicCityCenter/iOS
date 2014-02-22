//
//  MCCFloorplan.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCFloorplan : NSObject
{
}

@property(nonatomic,retain)NSString* floorplanId;
@property(nonatomic,retain)NSArray* locations;
@property(nonatomic,retain)NSArray* edges;

@end

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

@property (strong, nonatomic) MCCFloorplanLocation *start;
@property (strong, nonatomic) MCCFloorplanLocation *end;
@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat angle;

@end

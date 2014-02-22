//
//  MCCFloorplan.m
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCFloorplan.h"

@implementation MCCFloorplan

-(id)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.locations = [[NSArray alloc] init];
    self.edges = [[NSArray alloc] init];
    
    return self;
}

@end

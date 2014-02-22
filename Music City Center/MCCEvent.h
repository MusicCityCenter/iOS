//
//  MCCEvent.h
//  Music City Center
//
//  Created by Jules White on 2/22/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCEvent : NSObject
{
    
}

@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger day;
@property(nonatomic) NSInteger year;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* description;

// An id of a MCCFloorplanLocation
@property(nonatomic,retain) NSString* locationId;

@end

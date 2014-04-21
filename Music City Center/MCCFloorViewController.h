//
//  MCCFloorViewController.h
//  Music City Center
//
//  Created by Clark Perkins on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCFloorPlanLocation;

@interface MCCFloorViewController : UIViewController

- (void)setPolylineToFloorPlanLocation:(MCCFloorPlanLocation *)location andLocationData:(NSDictionary *)locationData;
- (void)setPolylineToFloorPlanLocation:(MCCFloorPlanLocation *)endLocation fromFloorPlanLocation:(MCCFloorPlanLocation *)startLocation;

@end

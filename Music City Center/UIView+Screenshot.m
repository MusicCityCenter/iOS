//
//  UIView+Screenshot.m
//  Music City Center
//
//  Created by Seth Friedman on 2/4/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)convertViewToImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self drawViewHierarchyInRect:self.bounds
               afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

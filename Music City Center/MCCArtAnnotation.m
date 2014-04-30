//
//  MCCArtAnnotation.m
//  Music City Center
//
//  Created by Seth Friedman on 3/20/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCArtAnnotation.h"

@implementation MCCArtAnnotation

#pragma mark - Designated Initializer

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image {
    self = [super init];
    
    if (self) {
        _title = title;
        _coordinate = coordinate;
        _image = image;
    }
    
    return self;
}

#pragma mark - Factory Method

+ (instancetype)artAnnotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image {
    return [[self alloc] initWithTitle:title
                            coordinate:coordinate
                              andImage:image];
}

@end

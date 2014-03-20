//
//  MCCArtAnnotation.h
//  Music City Center
//
//  Created by Seth Friedman on 3/20/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface MCCArtAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImage *image; // TODO - Change to imageURL once we get a way to fetch that from the server

- (instancetype)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image;

+ (instancetype)artAnnotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image;

@end

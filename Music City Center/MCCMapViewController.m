//
//  MCCViewController.m
//  Music City Center
//
//  Created by Clark Perkins on 2/3/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCMapViewController.h"
#import "MCCFloorViewController.h"
#import "UIView+Screenshot.h"
#import <GPUImage/GPUImage.h>

static NSString * const identifier = @"Cell";

@interface MCCMapViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) GPUImageView *blurView;
@property (strong, nonatomic) GPUImageiOSBlurFilter *blurFilter;

@end

@implementation MCCMapViewController

#pragma mark - Custom Getter

- (GPUImageiOSBlurFilter *)blurFilter {
    if (!_blurFilter) {
        _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        _blurFilter.blurRadiusInPixels = 4.0f;
    }
    
    return _blurFilter;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class]
                                                forCellReuseIdentifier:identifier];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor clearColor];
    
    self.blurView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    self.blurView.clipsToBounds = YES;
    self.blurView.layer.contentsGravity = kCAGravityBottom;
    self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    
    [self.view addSubview:self.blurView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Search Display Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self updateBlur];
    
    CGRect deviceSize = [UIScreen mainScreen].bounds;
    
    [UIView animateWithDuration:0.25f animations:^(void){
        self.blurView.frame = CGRectMake(0, 66.0f, deviceSize.size.width, deviceSize.size.height);
        self.blurView.layer.contentsRect = CGRectMake(0.0f, (66.0f / deviceSize.size.height), 1.0f, 1.0f);
        self.blurView.layer.contentsScale = 2.0f;
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIView animateWithDuration:0.25f animations:^{
        self.blurView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        self.blurView.layer.contentsRect = CGRectMake(0.0f, 0.0f, 1.0f, 0.0f);
    }];
}

#pragma mark - Blur Effect

- (void)updateBlur {
    UIImage *image = [self.view.superview convertViewToImage];
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    [picture addTarget:self.blurFilter];
    [self.blurFilter addTarget:self.blurView];
    
    [picture processImageWithCompletionHandler:^{
        [self.blurFilter removeAllTargets];
    }];
}

@end

//
//  MCCSearchDisplayController.h
//  Music City Center
//
//  Created by Clark Perkins on 3/25/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCSearchDisplayController : NSObject

@property(nonatomic, getter=isActive) BOOL active;
@property(nonatomic, assign) id<UISearchDisplayDelegate> delegate;
@property(nonatomic, assign) BOOL displaysSearchBarInNavigationBar;
@property(nonatomic, readonly) UINavigationItem *navigationItem;
@property(nonatomic, readonly) UISearchBar *searchBar;
@property(nonatomic, readonly) UIViewController *searchContentsController;
@property(nonatomic, assign) id<UITableViewDataSource> searchResultsDataSource;
@property(nonatomic, assign) id<UITableViewDelegate> searchResultsDelegate;
@property(nonatomic, readonly) UITableView *searchResultsTableView;
@property(nonatomic, copy) NSString *searchResultsTitle;

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController;
- (void)setActive:(BOOL)visible animated:(BOOL)animated;

@end

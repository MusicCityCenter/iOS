//
//  MCCSearchDisplayController.m
//  Music City Center
//
//  Created by Clark Perkins on 3/25/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCSearchDisplayController.h"

@interface MCCSearchDisplayController ()

@property(nonatomic, readwrite) UINavigationItem *navigationItem;
@property(nonatomic, readwrite) UISearchBar *searchBar;
@property(nonatomic, readwrite) UIViewController *searchContentsController;
@property(nonatomic, readwrite) UITableView *searchResultsTableView;

@end

@implementation MCCSearchDisplayController

-(id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
    self = [super init];
    
    if (self) {
        _searchBar = searchBar;
        _searchContentsController = viewController;
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)coder {
//    NSLog(@"%@", [coder decodeObjectForKey:@"searchContentsController"]);
    self = [self initWithSearchBar:nil contentsController:nil];
    return self;
}

-(void)hidNavigationBar {
    
}

-(void)setActive:(BOOL)active {
    [self setActive:active animated:NO];
}

-(void)setActive:(BOOL)visible animated:(BOOL)animated {
    // Do nothing for now
}

- (void)setDisplaysSearchBarInNavigationBar:(BOOL)displaysSearchBarInNavigationBar {
    if (_displaysSearchBarInNavigationBar && !displaysSearchBarInNavigationBar) {
        _displaysSearchBarInNavigationBar = NO;
        self.navigationItem = nil;
    } else if (!_displaysSearchBarInNavigationBar && displaysSearchBarInNavigationBar) {
        _displaysSearchBarInNavigationBar = YES;
        self.navigationItem = [[UINavigationItem alloc] init];
        self.navigationItem.titleView = self.searchBar;
    }
}

-(UITableView *)searchResultsTableView {
    if (!_searchResultsTableView) {
        _searchResultsTableView = [[UITableView alloc] initWithFrame:CGRectNull
                                                               style:UITableViewStyleGrouped];
        _searchResultsTableView.delegate = self.searchResultsDelegate;
        _searchResultsTableView.dataSource = self.searchResultsDataSource;
    }
    return _searchResultsTableView;
}

@end

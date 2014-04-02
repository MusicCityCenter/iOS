//
//  MCCSearchDisplayController.m
//  Music City Center
//
//  Created by Clark Perkins on 3/25/14.
//  Copyright (c) 2014 Music City Center. All rights reserved.
//

#import "MCCSearchDisplayController.h"

@implementation MCCSearchDisplayController

//-(id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
//    self = [super initWithSearchBar:searchBar
//                 contentsController:viewController];
//    
//    if (self) {
//        [self setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
//                forKey:@"_searchResultsTableViewStyle"];
//    }
//    
//    return self;
//}

-(UITableView *)searchResultsTableView {
    [self setValue:[NSNumber numberWithInt:UITableViewStyleGrouped]
            forKey:@"_searchResultsTableViewStyle"];
    return [super searchResultsTableView];
}

@end

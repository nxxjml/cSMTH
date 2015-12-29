//
//  BoardListTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/28.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "SMTHURLConnection.h"
#import "ArticleListTableViewController.h"

@interface BoardListTableViewController : UITableViewController<UISearchControllerDelegate, UISearchBarDelegate>
@property (retain, nonatomic) UISearchController *searchController;
@property (nonatomic) BOOL *searchMode;
@property (copy, nonatomic) NSMutableArray *boardArray;
@property (copy, nonatomic) NSMutableArray *directoryArray;
@property (nonatomic) NSInteger boardID;
@property (nonatomic) NSInteger sectionID;

@property (nonatomic) NSInteger flag;
@end

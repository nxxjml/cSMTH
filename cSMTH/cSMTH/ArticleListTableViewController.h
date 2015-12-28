//
//  ArticleListTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/25.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTHURLConnection.h"

@interface ArticleListTableViewController : UITableViewController<UISearchControllerDelegate, UISearchBarDelegate>
@property (copy, nonatomic) NSString *boardID;
@property (copy, nonatomic) NSString *boardName;
@property (nonatomic) NSRange threadRange;
@property (retain, nonatomic) NSMutableArray *threads;
@property (nonatomic) NSInteger originalThreadLoaded;
@property (retain,nonatomic) NSMutableArray *orginalThread;
@property (nonatomic) BOOL searchMode;
@property (copy, nonatomic) NSString  *searchString;
@property (nonatomic) NSInteger selectedIndex;
@property (retain, nonatomic) UISearchController *searchController;



@end

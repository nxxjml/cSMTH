//
//  FavBoardListTableViewController.h
//  cSMTH
//
//  Created by simao on 16/1/1.
//  Copyright © 2016年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTHURLConnection.h"
#import "MJRefresh.h"
#import "ArticleListTableViewController.h"

@interface FavBoardListTableViewController : UITableViewController

@property (copy, nonatomic) NSMutableArray *boardsArray;

- (IBAction)addBoard:(id)sender;

@end

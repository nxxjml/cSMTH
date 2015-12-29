//
//  ArticleListTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/25.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ArticleListTableViewController.h"
#import "ArticleListTableViewCell.h"
#import "ArticleContentTableViewController.h"
#import "MJRefresh.h"
@interface ArticleListTableViewController ()
{
    NSInteger threadLoaded;
    SMTHURLConnection *api;
}
@end

@implementation ArticleListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    api = [[SMTHURLConnection alloc] init];
    [api init_smth];
    threadLoaded = 0;
//    api.delegate = self;
    _threads = [[NSMutableArray alloc] init];
    _threadRange = NSMakeRange(threadLoaded, 20);
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil]; //注意使用init和initWithSearchResultsController的区别
    _searchController.searchBar.scopeButtonTitles = @[@"标题", @"用户"];
    _searchController.dimsBackgroundDuringPresentation = NO;
//    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
//    _searchController.searchBar.frame =
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pressSearchButton:)];
    [self.navigationItem setRightBarButtonItem:searchBar];
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDataDirectly)];
    //    self.tableView.mj_header
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    [self fetchData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressSearchButton:(UIBarButtonItem*)sender {
    NSLog(@"start search");
    if (self.tableView.tableHeaderView == nil)  {
        CGRect frame = _searchController.searchBar.frame;
        NSLog(@"start search2");
//        NSLog(@"searchbar frame is %f,%f,%f,%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        [self.tableView setTableHeaderView:_searchController.searchBar];
        [self.tableView scrollRectToVisible:_searchController.searchBar.frame animated:NO];
        _searchController.active  = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
//    return [_threads count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
//    return [_threads[section] count];
    NSLog(@"threads count is %lu", [_threads count]);
    return [_threads count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_threads == nil) {
        return;
    }
    NSInteger threshold = [_threads count] -5;
    NSLog(@"threshold is %ld", threshold);
    if (indexPath.row == threshold) {
        [self fetchMoreData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ArticleListCell"];
    NSDictionary *thread = _threads[indexPath.row];
    [cell configureCell:thread];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"ArticleContent"]) {
        ArticleContentTableViewController *acvc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDictionary *thread = _threads[indexPath.row];
        NSNumber *aID = [thread objectForKey:@"id"];
        acvc.articleID = [aID integerValue];
        acvc.boardID = [thread objectForKey:@"board_id"];
        acvc.boardName = [thread objectForKey:@"board_name"];
        acvc.title = [thread objectForKey:@"subject"];
        acvc.hidesBottomBarWhenPushed = YES;
        if ([[thread objectForKey:@"flags"] hasPrefix:@"*"]) {
            NSMutableDictionary *readThread= [[NSMutableDictionary alloc] initWithDictionary:thread];
            NSString *flags = [thread objectForKey:@"flags"];
            NSRange r = [flags rangeOfString:@"*"];
            flags = [NSString stringWithFormat:@" %@", [flags substringFromIndex:(r.location + r.length)]];
            [readThread setValue:flags forKey:@"flags"];
            _threads[indexPath.row] = readThread;
            
        
        }
        
        
    } else if ([segue.identifier isEqualToString:@"Compose"]) {
        
    }
}


- (void)fetchMoreData {
//    NSLog(@"threadloaded is %ld", threadLoaded);
    _threadRange = NSMakeRange(threadLoaded, 20);
    NSString *boardID = _boardID;
    BOOL currentMode = _searchMode;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *threadSection;
        [api reset_status];
        if (_searchMode) {
            if (self.selectedIndex == 0) {
                threadSection = [api net_SearchArticle:boardID :_searchString :nil :_threadRange.location :_threadRange.length];
            } else if (self.selectedIndex == 1) {
                threadSection = [api net_SearchArticle:boardID :nil :_searchString :_threadRange.location :_threadRange.length];
            }
        } else {
            threadSection = [api net_LoadThreadList:boardID :_threadRange.location :_threadRange.length :2]; //最后一个参数“2”代表 notclear
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_searchMode != currentMode) {
                return ;
            }
            if (threadSection != nil) {
                threadLoaded += [threadSection count];
//                if (!_searchMode) {
//                    threadSection = threadSection
//                }
                [_threads addObjectsFromArray:threadSection];
                [self.tableView reloadData];
            }
        });
        
    });
}


- (void)fetchDataDirectly {
//    [_threads removeAllObjects];
    threadLoaded = 0;
    NSString *boardID = _boardID;
    BOOL currentMode = _searchMode;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *threadSection;
        [api reset_status];
        threadSection  = [api net_LoadThreadList:boardID :_threadRange.location :_threadRange.length :2];
        NSLog(@"thread refresh finished!");
//        NSLog(@"threadSection is %@", threadSection);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            if (currentMode != _searchMode) {
                return ;
            }
            if (threadSection != nil) {
                [_threads removeAllObjects];
                threadLoaded += [threadSection count];
                [_threads addObjectsFromArray:threadSection];
                NSLog(@"length of threads is %lu, threads is %@", (unsigned long)[_threads count], _threads);
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_header endRefreshing];
            }
            
        });
    });
    [self.refreshControl endRefreshing];
}

- (void)fetchData{
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
    NSLog(@"fetch data!!");
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.tableView.tableHeaderView = nil;
    _searchMode = NO;
    self.tableView.mj_header.hidden = NO;
    _threads = _orginalThread;
    threadLoaded = _originalThreadLoaded;
    _orginalThread = nil;
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    _searchMode = YES;
    [self.tableView.mj_header endRefreshing];
    self.tableView.mj_header.hidden = YES;
    _orginalThread = _threads;
    _originalThreadLoaded = threadLoaded;
    threadLoaded = 0;
    [self.searchController.searchBar becomeFirstResponder];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void) searchForText:(NSString*)searchString :(int)scope {
    if (searchString == nil) {
        return;
    }
    if (_boardID) {
        NSString *boardID = _boardID;
        threadLoaded = 0;
        NSInteger currentMode = _searchMode;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *results;
            [api reset_status];
            if (scope == 0) {

                results = [api net_SearchArticle:boardID :searchString :nil :_threadRange.location :_threadRange.length];
            } else if (scope == 1) {
                results = [api net_SearchArticle:boardID :nil :searchString :_threadRange.location :_threadRange.length];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (currentMode != _searchMode) {
                    return;
                }
                [_threads removeAllObjects];
                [_threads addObject:results];
                threadLoaded += [results count];
            });
        });
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

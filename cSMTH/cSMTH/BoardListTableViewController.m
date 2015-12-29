//
//  BoardListTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/28.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "BoardListTableViewController.h"

@interface BoardListTableViewController ()
{
    SMTHURLConnection *api;
}

@end

@implementation BoardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    api = [[SMTHURLConnection alloc] init];
    [api init_smth];
//    api.delegate = self;
    _boardID = 0;
    _sectionID = 0;
    _flag = 0;
    _boardArray = [[NSMutableArray alloc] init];

    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil]; //注意使用init和initWithSearchResultsController的区别
//    _searchController.searchBar.scopeButtonTitles = @[@"标题", @"用户"];
    _searchController.dimsBackgroundDuringPresentation = NO;
    //    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.delegate = self;
    _searchController.searchBar.delegate = self;
    //    _searchController.searchBar.frame =
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pressSearchButton:)];
     [self.navigationItem setRightBarButtonItem:searchBar];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDataDirectly)];
    //    self.tableView.mj_header
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    [self fetchData];    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_boardArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *board = [[NSDictionary alloc] init];
    board = _boardArray[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSInteger bdFlag = [(NSNumber*)[board objectForKey:@"flag"] integerValue];
    NSLog(@"board is %@,flag is %ld", board, bdFlag);
    if ((bdFlag != -1) && ((bdFlag & 0x400) == 0)) {//版面
        cell = [tableView dequeueReusableCellWithIdentifier:@"board" forIndexPath:indexPath];
        cell.textLabel.text = [board objectForKey:@"name"];
        cell.detailTextLabel.text = [board objectForKey:@"board_id"];
        NSLog(@"现在显示的是版面%@", [board objectForKey:@"name"]);
    } else {//文件夹
         cell = [tableView dequeueReusableCellWithIdentifier:@"directory" forIndexPath:indexPath];
        NSString *name = [board objectForKey:@"name"];
        NSRange r = [name rangeOfString:@" "];
        if (r.length != 0) {
            cell.textLabel.text = [name substringToIndex:r.location];
            cell.detailTextLabel.text = [name substringFromIndex:(r.location + r.length)];
            
        } else {
            cell.textLabel.text = name;
            cell.detailTextLabel.text = nil;
        }
         NSLog(@"现在显示的是文件夹%@", cell.textLabel.text);
        
    }
   
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *board = [[NSDictionary alloc] init];
    board = _boardArray[indexPath.row];
    NSInteger bdFlag = [(NSNumber*)[board objectForKey:@"flag"] integerValue];
    if ((bdFlag == -1) || ((bdFlag > 0) &&  ((bdFlag & 0x400) != 0))) {
        BoardListTableViewController *blvc =[[BoardListTableViewController alloc] init];
        blvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardListTableViewController"];
        NSRange r = [[board objectForKey:@"name"] rangeOfString:@" "];
        if (r.length != 0) {
            blvc.title = [[board objectForKey:@"name"] substringToIndex:r.location];
        } else {
            blvc.title = [board objectForKey:@"name"];
        }
        NSInteger boardID = [(NSNumber*)[board objectForKey:@"bid"] integerValue];
        NSInteger sectionID = [(NSNumber*)[board objectForKey:@"section"] integerValue];
        NSInteger flag = [(NSNumber*)[board objectForKey:@"flag"] integerValue];
        blvc.boardID = boardID;
        blvc.sectionID = sectionID;
        blvc.flag = flag;
        NSLog(@"boardid is %ld, sectionID is %ld, flag is %ld", boardID, sectionID, flag);
        [self showViewController:blvc sender:self];
        
    }

    
    
}

- (void)fetchDataDirectly {
    BOOL currentMode = _searchMode;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *boardList;
    [api reset_status];
    if ((_flag > 0) && ((_flag & 0x400) != 0)) {
        boardList  = [api net_ReadSection:_sectionID :_boardID];
    } else {
        boardList  = [api net_LoadBoards:_boardID];
    }
    
//    NSLog(@"thread refresh finished!");
    //        NSLog(@"threadSection is %@", threadSection);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"boardlist is %@", boardList);
        [self.tableView.mj_header endRefreshing];
        [self.boardArray removeAllObjects];
        [_boardArray addObjectsFromArray:boardList];
        [self.tableView reloadData];
        
    });
});
[self.refreshControl endRefreshing];
}

- (void)fetchMoreData {
    
}

- (void)fetchData {
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;

}

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

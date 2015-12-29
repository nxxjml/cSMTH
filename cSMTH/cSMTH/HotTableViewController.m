//
//  HotTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/16.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "HotTableViewController.h"
//#import "SMTHURLConnection.h"
#import "smth_netop.h"
#import "MJRefresh.h"
#import "HotTableViewCell.h"
#import "ArticleContentTableViewController.h"


@interface HotTableViewController ()
@property (retain, nonatomic) SMTHURLConnection *api;

@end

@implementation HotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //初始化水木API
    _api = [[SMTHURLConnection alloc] init];
    [_api init_smth];
    _api.delegate = self;
    self.navigationItem.title = @"热点话题";
    
    self.contentArray = [[NSMutableArray alloc] init];
    
    _sectionsArray = [NSMutableArray arrayWithArray:@[@{@"code": @"", @"description": @"", @"name": @"本日十大热门话题", @"bdId": @0},
                                                      @{@"code": @"", @"description": @"", @"name": @"国内院校", @"bdId": @2},
                                                      @{@"code": @"", @"description": @"", @"name": @"休闲娱乐", @"bdId": @3},
                                                      @{@"code": @"", @"description": @"", @"name": @"五湖四海", @"bdId": @4},
                                                      @{@"code": @"", @"description": @"", @"name": @"游戏运动", @"bdId": @5},
                                                      @{@"code": @"", @"description": @"", @"name": @"社会信息", @"bdId": @6},
                                                      @{@"code": @"", @"description": @"", @"name": @"知性感性", @"bdId": @7},
                                                      @{@"code": @"", @"description": @"", @"name": @"文化人文", @"bdId": @8},
                                                      @{@"code": @"", @"description": @"", @"name": @"学术科学", @"bdId": @9},
                                                      @{@"code": @"", @"description": @"", @"name": @"电脑技术", @"bdId": @10}]];
    
//    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    //为tableview添加下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    NSString *userName = @"merl";
    NSString *passWord = @"831117jxf";
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        [_api reset_status];
//        NSInteger loginSuccess =  [self.api net_LoginBBS:userName :passWord];
//        dispatch_async(dispatch_get_main_queue(), ^(){
//            if (loginSuccess != 0 && _api->net_error == 0) {
//                NSLog(@"Login successfully!!");
//            }
//        });
//    });
    loginSuccess = 0;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        [_api reset_status];
//        loginSuccess =  [self.api net_LoginBBS:@"merl" :@"831117jxf"];
//        NSLog(@"loginSuccess is %ld", loginSuccess);
//        int errorCode = _api->net_error;
//        NSLog(@"error code is %d", errorCode);
//        
////        NSMutableArray *content = [[NSMutableArray alloc] initWithCapacity:10];
////        for (NSDictionary *section in _sectionsArray) {
////            [self.api reset_status];
////            NSArray *rawThreads = [_api net_LoadSectionHot:(long)[section objectForKey:@"bdId"]];
////            [content addObject:rawThreads];
////            NSInteger errorCode = (NSInteger)_api->net_error;
////                        NSLog(@"%@, errorCode is %ld", rawThreads, (long)errorCode);
////        }
//        dispatch_async(dispatch_get_main_queue(), ^(){
//             NSLog(@"loginSuccess is %ld", loginSuccess);
////            [self.tableView.mj_header endRefreshing];
////            //[self.contentArray removeAllObjects];
////            self.contentArray = content;
////            //            NSLog(@"contentArray is %@", content);
////            [self.tableView reloadData];
//            
//        });
//        
//    });
//    [self login];
   
    
    [self fetchDataDirectly];
    
//    if (_accessToken == nil) {
//        NSInteger errorCode = _api->net_error;
//        NSLog(@"error code is %ld", errorCode);
//        [_api reset_status];
//        [self.api net_LoginBBS:@"merl" :@"831117jxf"];
////        int loginSuccess = [_api net_LoginBBS:@"guest" :@""];
//        errorCode = _api->net_error;
//        NSLog(@"error code is %ld", errorCode);
//        if (loginSuccess != 0 && errorCode == 0) {
//            self.accessToken = apiGetAccessToken();
//            NSLog(@"token is  %@", self.accessToken);
//        }
//    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [_api reset_status];
    int loginSuc =  [self.api net_LoginBBS:@"merl" :@"831117jxf"];
    NSLog(@"loginSuc @ login is %d", loginSuc);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            loginSuccess = loginSuc;
            NSLog(@"loginSuccess @ login i %d", loginSuccess);
            
        });
    });
    
    
}

- (void)fetchData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    
    [self fetchDataDirectly];
}

- (void)fetchDataDirectly {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        if (loginSuccess == 0) {
            [_api reset_status];
            loginSuccess =  [self.api net_LoginBBS:@"merl" :@"831117jxf"];
             NSLog(@"loginSuccess @ fetchData is %ld", loginSuccess);
        }
        

//        NSLog(@"loginSuccess is %ld", loginSuccess);
        
        NSMutableArray *content = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *section in _sectionsArray) {
            [self.api reset_status];
            NSInteger sectionID = [(NSNumber*)[section objectForKey:@"bdId"] integerValue];
            NSArray *rawThreads = [_api net_LoadSectionHot:sectionID];
            [content addObject:rawThreads];
            NSInteger errorCode = (NSInteger)_api->net_error;
//            NSLog(@"section is %ld" section)
//            NSLog(@"%@, errorCode is %ld", rawThreads, (long)errorCode);
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView.mj_header endRefreshing];
            //[self.contentArray removeAllObjects];
            self.contentArray = content;
//           NSLog(@"contentArray is %@", content);
            [self.tableView reloadData];
            
        });
        
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return [self.contentArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [[self.contentArray objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Articles" forIndexPath:indexPath];
    cell.titleLabel.text = [self.contentArray[indexPath.section][indexPath.row] objectForKey:@"subject"];
    cell.boardLabel.text = [self.contentArray[indexPath.section][indexPath.row] objectForKey:@"board"];
    cell.authorLabel.text = [self.contentArray[indexPath.section][indexPath.row] objectForKey:@"author_id"];
    
//    CGRect frame = cell.frame;
//    frame.size.height = 200;
//    [cell setFrame:frame];
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  [self.contentArray[section] count] == 0 ? nil : [self.sectionsArray[section] objectForKey:@"name"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *dvc = segue.destinationViewController;
//    UINavigationController *nvc = (UINavigationController*)dvc;
//    if (nvc != nil) {
//        dvc = nvc.visibleViewController;
//    }
    
    ArticleContentTableViewController *acvc = (ArticleContentTableViewController*)dvc;
    UITableViewCell *cell = (UITableViewCell*)sender;
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *thread = _contentArray[indexpath.section][indexpath.row];
    NSNumber *aID = [thread objectForKey:@"id"];
    acvc.articleID = [aID integerValue];
    acvc.boardID = [thread objectForKey:@"board"];
    acvc.title = [thread objectForKey:@"subject"];
    acvc.fromTopTen = YES;
    acvc.hidesBottomBarWhenPushed  = YES;
    UIBarButtonItem *tempButtonItem = [[UIBarButtonItem alloc] init];
    tempButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = tempButtonItem;
    
    NSLog(@"articleID is %ld, boardID is %@", [aID integerValue], [thread objectForKey:@"board"]);
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

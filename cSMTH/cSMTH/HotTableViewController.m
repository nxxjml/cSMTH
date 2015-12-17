//
//  HotTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/16.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "HotTableViewController.h"
#import "SMTHURLConnection.h"
#import "MJRefresh.h"


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
    _api = [[SMTHURLConnection alloc] init];
    [_api init_smth];
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
    
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    if (_accessToken == nil) {
        NSInteger loginSuccess = [_api net_LoginBBS:@"guest" :@""];
        NSInteger errorCode = _api->net_error;
        if (loginSuccess != nil && errorCode == 0) {
            self.accessToken = [_api net_get]
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        for (NSDictionary *section in _sectionsArray) {
            NSArray *rawThreads = [_api net_LoadSectionHot:(long)[section objectForKey:@"bdId"]];
            [_contentArray arrayByAddingObjectsFromArray:rawThreads];
            NSInteger errorCode = (NSInteger)_api->net_error;
            NSLog(@"%@, errorCode is %ld", rawThreads, (long)errorCode);
            }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView.mj_header endRefreshing];
            NSLog(@"%@", self.contentArray);
            
        });

    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Articles" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

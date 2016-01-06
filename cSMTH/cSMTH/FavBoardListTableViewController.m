//
//  FavBoardListTableViewController.m
//  cSMTH
//
//  Created by simao on 16/1/1.
//  Copyright © 2016年 simao. All rights reserved.
//

#import "FavBoardListTableViewController.h"

@interface FavBoardListTableViewController ()
{
    SMTHURLConnection *api;
}

@end

@implementation FavBoardListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark init smth_api
    api = [[SMTHURLConnection alloc] init];
    [api init_smth];
    
    _boardsArray = [[NSMutableArray alloc] init];
    
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDataDirectly)];
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoreData)];
    
    [self fetchData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark fetchData
- (void)fetchDataDirectly {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *boards = [[NSArray alloc] init];
        [api reset_status];
        boards = [api net_LoadFavorites:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [_boardsArray removeAllObjects];
            [_boardsArray addObjectsFromArray:boards];
            NSLog(@"boards is %@", _boardsArray);
            [self.tableView reloadData];
            
        });
    });
    
}

- (void)fetchMoreData {

}

- (void)fetchData {
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_boardsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favBoard" forIndexPath:indexPath];
    NSMutableDictionary *board = [[NSMutableDictionary alloc] init];
    board = _boardsArray[indexPath.row];
    
    cell.textLabel.text = [board objectForKey:@"name"];
    cell.detailTextLabel.text = [board objectForKey:@"id"];
    
    // Configure the cell...
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    
//}


- (void)addBoard:(id)sender {
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert = [UIAlertController alertControllerWithTitle:@"请输入需要收藏的版面（英文）" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    UIAlertAction *okAction = [[UIAlertAction alloc] init];
    okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        [api reset_status];
        [self addFavoriteWithBoardID:textField.text];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)addFavoriteWithBoardID:(NSString *)boardID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api reset_status];
        [api net_AddFav:boardID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (api->net_error  == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self fetchData];
                });
                
            } else if (api->net_error == 10310) {
                
            }
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ArticleListTableViewController *alvc = (ArticleListTableViewController*)segue.destinationViewController;
    UITableViewCell *cell = (UITableViewCell*)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *board = _boardsArray[indexPath.row];
    
    alvc.boardID = [board objectForKey:@"id"];
    alvc.boardName = [board objectForKey:@"name"];
    alvc.title = [board objectForKey:@"name"];
    alvc.hidesBottomBarWhenPushed = YES;
    
    
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

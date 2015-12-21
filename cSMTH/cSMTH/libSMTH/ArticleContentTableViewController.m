//
//  ArticleContentTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/21.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ArticleContentTableViewController.h"
#import "ArticleContentTableViewCell.h"
#import "SMTHURLConnection.h"

@interface ArticleContentTableViewController ()
{
    NSMutableArray *smArticles;
    SMTHURLConnection *api;

}

@end

@implementation ArticleContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
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
    return [smArticles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleContetnCell" forIndexPath:indexPath];
    NSDictionary *smArticle = smArticles[indexPath.row];
    NSInteger floor = [smArticle objectForKey:@"floor"];
    [cell setData:floor :smArticle :self];
    cell.preservesSuperviewLayoutMargins = false;
    
    // Configure the cell...
    
    return cell;
}

- (void)fetchDataDirectly {
    [smArticles removeAllObjects];
    NSString *boardID = _boartdID;
    NSInteger articleID = _articleID;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//        let smArticles = self.api.getThreadContentInBoard(boardID, articleID: articleID, threadRange: self.threadRange, replyMode: self.setting.sortMode)
//        let totalArticleNumber = self.api.getLastThreadCount()
//        
//        if self.fromTopTen && self.boardName == nil { // get boardName
//            if let boards = self.api.queryBoard(boardID) {
//                for board in boards {
//                    if board.boardID == boardID {
//                        self.boardName = board.name
//                        break
//                    }
//                }
//            }
//        }
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            networkActivityIndicatorStop()
//            self.tableView.header.endRefreshing()
//            self.tableView.footer.hidden = false
//            if let smArticles = smArticles {
//                self.smarticles += smArticles
//                self.totalArticleNumber = totalArticleNumber
//                self.tableView?.reloadData()
//            }
//            self.api.displayErrorIfNeeded()
//        }
//    }
//} else {
//    self.tableView.header.endRefreshing()
//    tableView.footer.hidden = false
    
//}
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api reset_status];
        NSMutableArray *smArticles = [api net_GetThread:boardID :articleID :0 :10 :0];
        NSInteger totalArticleNumber  = [api net_GetLastThreadCnt];
        if (_fromTopTen && _boardName == nil) {
            [api reset_status];
            NSArray *boards = [api net_QueryBoard:boardID];
            if (boardID != nil) {
                for (NSDictionary *board in boards){
                    if ([board objectForKey:@"boardID"] == boardID) {
                        _boardName = [board objectForKey:@"name"];
                        break;
                    }
                }
            }
        
        }
        dispatch_get_main_queue()
        
        
        
    })

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

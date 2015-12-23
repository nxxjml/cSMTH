//
//  ArticleContentTableViewController.m
//  cSMTH
//
//  Created by simao on 15/12/21.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ArticleContentTableViewController.h"
#import "ArticleContentTableViewCell.h"
//#import "SMTHURLConnection.h"
#import "MJRefresh.h"

@interface ArticleContentTableViewController ()
{
//    NSMutableArray *smArticles;
    SMTHURLConnection *api;

}
@property (retain, nonatomic) NSMutableArray *smArticles;
@property (nonatomic) NSInteger totalArticleNumber;

@end

@implementation ArticleContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    api = [[SMTHURLConnection alloc] init];
    [api init_smth];
    api.delegate = self;
    _smArticles = [[NSMutableArray alloc] init];

//    self.tableView.estimatedRowHeight = 200;
//    NSLog(@"tableview  height is %f", self.tableView.frame.size.height);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:ArticleContentTableViewCell.self forCellReuseIdentifier:@"ArticleContentCell"];//设置tableview cell的class！！！
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchDataDirectly)];
//    self.tableView.mj_header
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchMoredata)];
//    self.tableView.mj_footer.
    [self fetchData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"smArticles count is %ld", [_smArticles count]);
    return [_smArticles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleContentCell"];
    if (cell == nil) {
        cell = [[ArticleContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArticleContentCell"];
        NSLog(@"cell init");
    }
    NSDictionary *smArticle = _smArticles[indexPath.row];
//    NSNumber *floorNum = [smArticle objectForKey:@"floor"];
//    NSInteger floor = [floorNum integerValue];
    NSInteger floor = indexPath.row;
    [cell setData:floor :smArticle :self];
//    NSLog(@"floor is %@",floorNum);÷
//    NSLog(@"cell content is %@", smArticle);
//    CGRect cellFrame = cell.frame;
//    cellFrame.size.height = 200;
//    [cell setFrame:cellFrame];
//    NSLog(@"cell height is %f,cell contentview height is %f", cell.frame.size.height,cell.contentView.frame.size.height);
    
//    cell.preservesSuperviewLayoutMargins = false;
    
    // Configure the cell...
    
    return cell;
}

- (void)fetchDataDirectly {
    [_smArticles removeAllObjects];
    NSString *boardID = _boardID;
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
        NSArray *smArticles = [api net_GetThread:boardID :articleID :0 :20 :0];
        int errorCode = api->net_error;
        NSLog(@"error code is %d ", errorCode);
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = YES;
            if (smArticles != nil) {
                [_smArticles removeAllObjects];
                [_smArticles addObjectsFromArray:smArticles];
                _totalArticleNumber = totalArticleNumber;
                [self.tableView reloadData];
                NSLog(@"article content is %@", _smArticles[0]);
            } else {
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = NO;
            }
            
            
            
        });
        
        
        
    });

}

- (void)fetchData{
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
}

- (void)fetchMoredata{
    NSString *boardID = _boardID;
    NSInteger articleID = _articleID;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *smArticles =[api net_GetThread:boardID :articleID :0 :10 :0];
//        NSInteger newIndexs = [self.smArticles cou];
//    })
//    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
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

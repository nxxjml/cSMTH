//
//  ArticleContentTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/21.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTHURLConnection.h"

@interface ArticleContentTableViewController : UITableViewController<SMTHURLConnectionDelegate>
{
    

}

@property(copy,nonatomic) NSString *boardID;
@property (copy, nonatomic) NSString *boardName;
@property (nonatomic) NSInteger articleID;
@property (nonatomic) BOOL fromTopTen;
- (IBAction)enterBoard:(id)sender;


@end

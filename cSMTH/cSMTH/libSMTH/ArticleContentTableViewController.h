//
//  ArticleContentTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/21.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleContentTableViewController : UITableViewController
{
    

}

@property(copy,nonatomic) NSString *boartdID;
@property (copy, nonatomic) NSString *boardName;
@property (nonatomic) NSInteger articleID;
@property (nonatomic) BOOL fromTopTen;

@end

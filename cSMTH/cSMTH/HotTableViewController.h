//
//  HotTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/16.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewController : UITableViewController
@property (copy, nonatomic) NSMutableArray *sectionsArray;
@property (copy, nonatomic) NSMutableArray *contentArray;
@property (copy, nonatomic) NSString *accessToken;

@end

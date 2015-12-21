//
//  HotTableViewController.h
//  cSMTH
//
//  Created by simao on 15/12/16.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTHURLConnection.h"

@interface HotTableViewController : UITableViewController<SMTHURLConnectionDelegate>
{
    NSInteger loginSuccess;
}
@property (copy, nonatomic) NSMutableArray *sectionsArray;
@property (copy, nonatomic) NSMutableArray *contentArray;
@property (copy, nonatomic) NSString *accessToken;


@end

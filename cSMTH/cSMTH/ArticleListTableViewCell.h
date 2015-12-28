//
//  ArticleListTableViewCell.h
//  cSMTH
//
//  Created by simao on 15/12/25.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (retain, nonatomic) NSMutableArray *thread;

- (void)configureCell:(NSDictionary*)thread;


@end

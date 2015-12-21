//
//  ArticleContentTableViewCell.h
//  cSMTH
//
//  Created by simao on 15/12/19.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface ArticleContentTableViewCell : UITableViewCell<TTTAttributedLabelDelegate>
{
    UIButton *authorButton;
    UILabel *floorAndTimeLabel;
    UIButton *replyButton;
    UIButton *moreButton;
    NSMutableArray *imageViews;
    
    TTTAttributedLabel *contentLabel;
    UITableViewController *controller;
    
    int displayFloor;
    CGFloat blankWidth;
    CGFloat picNumPerLine;
    
    
}
- (void)setup;
- (void)setData:(NSInteger)floor :(NSDictionary *)smArticle :(UITableViewController *)controller;

@end

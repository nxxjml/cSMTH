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
    
}

@property (retain, nonatomic) UIButton *authorButton;
@property (retain, nonatomic) UILabel *floorAndTimeLabel;
@property (retain, nonatomic) UIButton *replyButton;
@property (retain, nonatomic) UIButton *moreButton;
@property (retain, nonatomic) NSMutableArray *imageViews;

@property (retain, nonatomic) TTTAttributedLabel *contentLabel;
@property (retain, nonatomic) UITableViewController *controller;

@property (nonatomic) int displayFloor;
@property (nonatomic)  CGFloat blankWidth;
@property (nonatomic) CGFloat picNumPerLine;


- (void)setup;
- (void)setData:(NSInteger)floor :(NSDictionary *)smArticle :(UITableViewController *)controller;

@end

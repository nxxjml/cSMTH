//
//  ArticleListTableViewCell.m
//  cSMTH
//
//  Created by simao on 15/12/25.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ArticleListTableViewCell.h"
@interface ArticleListTableViewCell()
{
    BOOL isAlwaysOnTop;
    BOOL hasAttachment;
    
}
@end

@implementation ArticleListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSDictionary *)thread {
    NSString *flags = (NSString*)[thread objectForKey:@"flags"];
    if ([flags hasPrefix:@"D"] || [flags hasPrefix:@"d"]) {
        isAlwaysOnTop = YES;
    } else {
        isAlwaysOnTop = NO;
    }
    NSRange range;
    range = [flags rangeOfString:@"@"];
    if (range.length != 0) {
        hasAttachment = YES;
    } else {
        hasAttachment = NO;
    }
    
    _titleLabel.text = [[thread objectForKey:@"subject"] stringByAppendingString:(hasAttachment ? @"🔗" : @"")];
    if (isAlwaysOnTop) {
        _titleLabel.textColor = [UIColor redColor];
        
    } else {
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    _authorLabel.text = [thread objectForKey:@"author_id"];
    NSNumber *lastTime = [thread objectForKey:@"last_time"];
    
    NSTimeInterval timeInterval = [lastTime doubleValue];
    NSDate *timeAndDate = [NSDate dateWithTimeIntervalSince1970: timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    _timeLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:timeAndDate]];
    
    _replyLabel.text = [NSString stringWithFormat:@"%@💬", [thread objectForKey:@"count"]];
    
    if ([flags hasPrefix:@"*"]) {
        _unreadLabel.hidden = YES;
        
    } else {
        _unreadLabel.hidden = NO;
    }
    
    //[_authorLabel setTextColor:[[UIApplication sharedApplication] keyWindow].tintColor];
    //[_unreadLabel setTextColor:[[UIApplication sharedApplication] keyWindow].tintColor];
    
}

@end

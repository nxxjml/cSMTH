//
//  ArticleContentTableViewCell.m
//  cSMTH
//
//  Created by simao on 15/12/19.
//  Copyright © 2015年 simao. All rights reserved.
//

#import "ArticleContentTableViewCell.h"

@implementation ArticleContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
}

- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tintColor = [[UIApplication sharedApplication] keyWindow].tintColor;
    self.clipsToBounds = true;
    
    authorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:authorButton];
    
    floorAndTimeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:floorAndTimeLabel];
    
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    replyButton.layer.cornerRadius = 4;
    replyButton.layer.borderWidth = 1;
    replyButton.layer.borderColor = self.tintColor.CGColor;
    replyButton.clipsToBounds = true;
    [replyButton addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:replyButton];
    
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    moreButton.layer.cornerRadius = 4;
    moreButton.layer.borderWidth = 1;
    moreButton.layer.borderColor = self.tintColor.CGColor;
    [moreButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreButton];
    
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contentLabel.delegate = self;
    contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    contentLabel.extendsLinkTouchArea = false;
    contentLabel.linkAttributes = @{NSForegroundColorAttributeName:self.tintColor};
    contentLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[self.tintColor colorWithAlphaComponent:0.6]};
    [self.contentView addSubview:contentLabel];
    
    
}

- (void)setData:(NSInteger)floor :(NSDictionary *)smArticle :(UITableViewController *)controller {
    displayFloor = floor;
    self->controller = controller;
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    authorButton.sizeToFit()
//    authorButton.frame = CGRect(origin: CGPoint(x: 8, y: 0), size: authorButton.bounds.size)
//    floorAndTimeLabel.sizeToFit()
//    floorAndTimeLabel.frame = CGRect(origin: CGPoint(x: 8, y: 26), size: floorAndTimeLabel.bounds.size)
//    replyButton.frame = CGRect(x: CGFloat(UIScreen.screenWidth()-94), y: 14, width: 40, height: 24)
//    moreButton.frame = CGRect(x: CGFloat(UIScreen.screenWidth()-44), y: 14, width: 36, height: 24)
//    
//    var imageLength: CGFloat = 0
//    if imageViews.count == 1 {
//        imageLength = contentView.bounds.width
//    } else if imageViews.count > 1 {
//        let oneImageLength = (contentView.bounds.width - (picNumPerLine - 1) * blankWidth) / picNumPerLine
//        imageLength = (oneImageLength + blankWidth) * ceil(CGFloat(imageViews.count) / picNumPerLine) - blankWidth
//    }
//    contentLabel.frame = CGRect(x: 8, y: 52, width: CGFloat(UIScreen.screenWidth()-16), height: contentView.bounds.height - 60 - imageLength)
//    
//    let size = contentView.bounds.size
//    if imageViews.count == 1 {
//        imageViews.first!.frame = CGRect(x: 0, y: size.height - size.width, width: size.width, height: size.width)
//    } else {
//        for (index, imageView) in imageViews.enumerate() {
//            let length = (size.width - (picNumPerLine - 1) * blankWidth) / picNumPerLine
//            let startY = size.height - ((length + blankWidth) * ceil(CGFloat(imageViews.count) / picNumPerLine) - blankWidth)
//            let offsetY = (length + blankWidth) * CGFloat(index / Int(picNumPerLine))
//            let X = 0 + CGFloat(index % Int(picNumPerLine)) * (length + blankWidth)
//            imageView.frame = CGRectMake(X, startY + offsetY, length, length)
//        }
//    }
    [authorButton sizeToFit];
    authorButton.frame = CGRectMake(0, 0, authorButton.bounds.size.width, authorButton.bounds.size.height);
    [floorAndTimeLabel sizeToFit];
    floorAndTimeLabel.frame = CGRectMake(8, 26, floorAndTimeLabel.bounds.size.width, floorAndTimeLabel.bounds.size.height);
    replyButton.frame = CGRectMake((CGFloat)([UIScreen mainScreen].bounds.size.width - 94), 14, 40, 24);
    moreButton.frame = CGRectMake((CGFloat)([UIScreen mainScreen].bounds.size.width - 44), 14, 36, 24);
    
    CGFloat imageLength = 0;
    if ([imageViews count] == 1) {
        imageLength = self.contentView.bounds.size.width;
    } else {
       
    };
    contentLabel.frame = CGRectMake(8, 52, [UIScreen mainScreen].bounds.size.width -16, self.contentView.bounds.size.height - 60 -imageLength);
    CGSize size = self.contentView.bounds.size;
    
    
}

@end
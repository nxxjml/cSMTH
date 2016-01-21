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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        [self layoutIfNeeded];
    }
//    CGRect frame = self.frame;
//    frame.size.height =100;
//    self.frame = frame;
    return self;
    }

- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tintColor = [[UIApplication sharedApplication] keyWindow].tintColor;
    self.clipsToBounds = true;
    CGRect cellFrame = [self.contentView frame];
//    NSLog(@"cell frame height is %f", cellFrame.size.height);
   
//    cellFrame.size.height = 44;
//    [self setFrame:cellFrame];
//    self.contentView.bounds = cellFrame;
    
//    NSLog(@"content view frame height is %f, bounds height is %f", self.contentView.frame.size.height, self.contentView.bounds.size.height);
    
    _authorButton = [[UIButton alloc] init];
    _authorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_authorButton setTitleColor:self.tintColor forState:UIControlStateNormal];
//    _authorButton.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_authorButton];
    
    _floorAndTimeLabel = [[UILabel alloc] init];
    _floorAndTimeLabel.font = [UIFont systemFontOfSize:15];
//    [_floorAndTimeLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:_floorAndTimeLabel];
    
    _replyButton = [[UIButton alloc] init];
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_replyButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _replyButton.layer.cornerRadius = 4;
    _replyButton.layer.borderWidth = 1;
    _replyButton.layer.borderColor = self.tintColor.CGColor;
//    _replyButton.clipsToBounds = true;
    [_replyButton addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_replyButton];
    
    _moreButton = [[UIButton alloc] init];
    [_moreButton setTitle:@"..." forState:UIControlStateNormal];
    [_moreButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _moreButton.layer.cornerRadius = 4;
    _moreButton.layer.borderWidth = 1;
    _moreButton.layer.borderColor = self.tintColor.CGColor;
    [_moreButton addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_moreButton];
    
    CGFloat imageLength = 0;
    if ([_imageViews count] == 1) {
        imageLength = self.contentView.bounds.size.width;
    } else {
        
    };
    
    _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    _contentLabel.delegate = self;
    _contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    _contentLabel.extendsLinkTouchArea = false;
    _contentLabel.linkAttributes = @{NSForegroundColorAttributeName:self.tintColor};
    _contentLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[self.tintColor colorWithAlphaComponent:0.6]};
    [self.contentView addSubview:_contentLabel];
//    NSLog(@"setup finished!!");
    
    
}

- (void)setData:(NSInteger)floor :(NSDictionary *)smArticle :(UITableViewController *)controller {
//    func setData(displayFloor floor: Int, smarticle: SMArticle, controller: UITableViewController?, delegate: ComposeArticleControllerDelegate) {
//        self.displayFloor = floor
//        self.controller = controller
//        self.delegate = delegate
//        self.article = smarticle
//        
//        authorButton.setTitle(smarticle.authorID, forState: .Normal)
//        let floorText = displayFloor == 0 ? "楼主" : "\(displayFloor)楼"
//        floorAndTimeLabel.text = "\(floorText)  \(smarticle.timeString)"
//        
//        contentLabel.setText(smarticle.attributedBody)
//        
//        drawImagesWithInfo(smarticle.imageAtt)
//    }
    _displayFloor = floor;
    NSLog(@"floor is %ld", floor);
    _controller = controller;
    [_authorButton setTitle:[smArticle objectForKey:@"author_id"] forState:UIControlStateNormal];
    NSString *floorText;
    floorText = (_displayFloor == 0) ? @"楼主" : [NSString stringWithFormat:@"%ld楼", floor];
    NSNumber *time = [smArticle objectForKey:@"time"];
    NSTimeInterval timeInterval = [time doubleValue];
    NSDate *timeAndDate = [NSDate dateWithTimeIntervalSince1970: timeInterval];
//    NSDate *time = [NSDate date];
//    NSLog(@"time is %@", timeAndDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle: NSDateFormatterShortStyle];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
//    NSLog(@"time after formate is %@", [formatter stringFromDate:timeAndDate]);
    
    [_floorAndTimeLabel setText:[NSString stringWithFormat:@"%@  %@", floorText, [formatter stringFromDate:timeAndDate]]];
    NSString *contentString = [smArticle objectForKey:@"body"];
    CGRect labelSize = [contentString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16, 9000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil];
    _cellHeight = ceil(labelSize.size.height);
//    CGRect frame = _contentLabel.frame;
//    NSLog(@"size is %f, %f", _contentLabel.frame.size.width, _contentLabel.frame.size.height);
//    frame.size.height = size.height;
//    [_contentLabel setFrame:frame];
//    [_contentLabel setBackgroundColor:[UIColor lightGrayColor]];
    [_contentLabel setText:[smArticle objectForKey:@"body"]];
    NSLog(@"HEIGHT is %f", _cellHeight);
    
    NSLog(@"setup data finished, body is %@", [smArticle objectForKey:@"body"]);

    
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
    [_authorButton sizeToFit];
    _authorButton.frame = CGRectMake(8, 0, _authorButton.bounds.size.width, _authorButton.bounds.size.height);
//    _authorButton.frame = CGRectMake(8, 10, 80, 20);

//    NSLog(@"width is %f, height is %f", _authorButton.bounds.size.width, _authorButton.bounds.size.height);
    [_floorAndTimeLabel sizeToFit];
    _floorAndTimeLabel.frame = CGRectMake(8, 26, _floorAndTimeLabel.bounds.size.width, _floorAndTimeLabel.bounds.size.height);
    
    _replyButton.frame = CGRectMake((CGFloat)([UIScreen mainScreen].bounds.size.width - 94), 14, 40, 24);
    _moreButton.frame = CGRectMake((CGFloat)([UIScreen mainScreen].bounds.size.width - 44), 14, 36, 24);
    
    CGFloat imageLength = 0;
    if ([_imageViews count] == 1) {
        imageLength = self.contentView.bounds.size.width;
    } else if ([_imageViews count] > 1) {
        CGFloat oneImageLength = (self.contentView.bounds.size.width - (_picNumPerLine - 1) * _blankWidth) / _picNumPerLine;
        imageLength = (oneImageLength + _blankWidth) * ceil((CGFloat)[_imageViews count] / _picNumPerLine ) - _blankWidth;
    };
    CGSize size = self.contentView.bounds.size;
    if ([_imageViews count] == 1) {
        [_imageViews.firstObject setFrame:CGRectMake(0, size.height - size.width, size.width, size.height)];
    } else {
        for (UIImageView* imageView in _imageViews) {
            CGFloat length = (size.width - (_picNumPerLine -1) * _blankWidth) / _picNumPerLine;
            CGFloat startY = size.height - ((length + _blankWidth) * ceil(((CGFloat) [_imageViews count]) / _picNumPerLine) - _blankWidth);
            CGFloat offsetY = (length + _blankWidth) * (CGFloat)([_imageViews indexOfObject:imageView] / (int)_picNumPerLine);
            CGFloat X = 0 + (CGFloat)([_imageViews indexOfObject:imageView] % (int)_picNumPerLine) * (length + _blankWidth);
            imageView.frame = CGRectMake(X, startY + offsetY, length, length);
            
        }
    }
    
    _contentLabel.frame = CGRectMake(8, 52, [UIScreen mainScreen].bounds.size.width -16, _cellHeight);//self.contentView.bounds.size.height - 60 -imageLength);
//    _contentLabel.frame = CGRectMake(8, 52, 300, 300);
//    _cellHeight = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
//    NSLog(@"cell height is %f +%f = %f", _contentLabel.frame.origin.y, _contentLabel.frame.size.height, _cellHeight);
    NSLog(@"content label width is %f, height is %f", _contentLabel.frame.size.width, _contentLabel.frame.size.height);
//    CGSize size = self.contentView.bounds.size;
    NSLog(@"layout finished");
    
    
}

@end
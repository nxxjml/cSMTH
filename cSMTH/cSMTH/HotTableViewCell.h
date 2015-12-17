//
//  HotTableViewCell.h
//  cSMTH
//
//  Created by simao on 15/12/16.
//  Copyright © 2015年 simao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

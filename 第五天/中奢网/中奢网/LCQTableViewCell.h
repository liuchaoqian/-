//
//  LCQTableViewCell.h
//  中奢网
//
//  Created by qf on 15/5/8.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

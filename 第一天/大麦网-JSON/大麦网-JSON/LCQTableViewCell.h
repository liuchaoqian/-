//
//  LCQTableViewCell.h
//  大麦网-JSON
//
//  Created by qf on 15/5/5.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

//@property (strong, nonatomic) NSOperationQueue * cellQueue;

-(void)setCellData:(NSDictionary *)dict;

@end

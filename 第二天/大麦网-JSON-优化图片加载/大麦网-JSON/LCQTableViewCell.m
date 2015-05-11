//
//  LCQTableViewCell.m
//  大麦网-JSON
//
//  Created by qf on 15/5/5.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQTableViewCell.h"

@implementation LCQTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

-(NSMutableDictionary *)imageDict
{
    if (_imageDict == nil) {
        _imageDict = [[NSMutableDictionary alloc] init];
    }
    return _imageDict;
}

-(void)setCellData:(NSDictionary *)dict
{
    self.icon.image = [UIImage imageNamed:@"photo"];
    NSString * projcetId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ProjectID"]];
    NSString * str = [projcetId substringToIndex:3];
    NSString * imageString = [NSString stringWithFormat:@"http://pimg.damai.cn/perform/project/%@/%@_n.jpg",str,projcetId];
    
    if (![[self.imageDict allKeys] containsObject:imageString]) {
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            NSURL * imageURL = [NSURL URLWithString:imageString];
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.icon.image = [UIImage imageWithData:imageData];
                
                [self.imageDict setObject:self.icon.image forKey:imageString];
            }];
            
        }];
    }else{
        UIImage * image = [self.imageDict objectForKey:imageString];
        self.icon.image = image;
    }
    
    
    self.titleLabel.text = [dict objectForKey:@"Name"];
    self.detailLabel.text = [dict objectForKey:@"Summary"];
    self.timeLabel.text = [dict objectForKey:@"ShowTime"];
    self.addressLabel.text = [dict objectForKey:@"VenName"];
    self.provinceLabel.text = [dict objectForKey:@"cityname"];
    self.priceLabel.text = [dict objectForKey:@"priceName"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

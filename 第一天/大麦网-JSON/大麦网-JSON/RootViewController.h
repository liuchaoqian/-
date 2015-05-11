//
//  RootViewController.h
//  大麦网
//
//  Created by qf on 15/4/23.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray * scrollArray;
@property (strong, nonatomic) NSMutableData * scrollData;
@property (retain, nonatomic) UITableView * tableView;
@property (retain, nonatomic) NSMutableArray * dateArray;
@property (retain, nonatomic) NSMutableData * tableDate;
@property (retain, nonatomic) NSMutableArray * cityDateArray;
@property (strong, nonatomic) NSURLConnection * tableConnection;

@end

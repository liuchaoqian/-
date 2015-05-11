//
//  FirstViewController.h
//  满座网
//
//  Created by qf on 15/4/26.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) UIButton * rightButton;
@property (retain, nonatomic) UIButton * allButton;
@property (retain, nonatomic) UIButton * sortButton;
@property (retain, nonatomic) UIScrollView * scrollView;
@property (retain, nonatomic) NSMutableArray * scrollArray;
@property (retain, nonatomic) UITableView * tableView;
@property (retain, nonatomic) NSMutableArray * dataArray;
@property (retain, nonatomic) UITableView * addresstableView;
@property (retain, nonatomic) NSMutableArray * addressArray;
@property (retain, nonatomic) UITableView * alltableView;
@property (retain, nonatomic) NSMutableArray * allArray;
@property (retain, nonatomic) UITableView * sorttableView;
@property (retain, nonatomic) NSMutableArray * sortArray;


@end

//
//  LCQAppDelegate.h
//  异步网络请求
//
//  Created by qf on 15/5/5.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCQAppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) NSMutableData * data;
@property (strong, nonatomic) UIImageView * imageView;

@end

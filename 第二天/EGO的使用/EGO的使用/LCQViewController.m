//
//  LCQViewController.m
//  ASIHTTPRequest用法
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "ASINetworkQueue.h"
#import "EGOImageView.h"

@interface LCQViewController ()
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray * images;

@end

@implementation LCQViewController
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 200)];
        _scrollView.pagingEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
-(NSMutableArray *)images
{
    if (_images == nil) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL * scrollURL = [NSURL URLWithString:@"http://mapi.damai.cn/hot201303/nindex.aspx?cityid=0&source=10099&version=30602"];
    
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:scrollURL];
    request.delegate = self;
    request.tag = 1;
    [request startSynchronous];
    
}
/**
 *  -EGO的使用
 */
-(void)requestFinished:(ASIHTTPRequest *)request
{
        NSArray * imagesArray = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary * dict in imagesArray) {
            NSURL * imageURL = [NSURL URLWithString:[dict objectForKey:@"Pic"]];
            [self.images addObject:imageURL];
        }
        
        self.scrollView.contentSize = CGSizeMake(self.images.count * 320, 0);
        
        /**
         *  -EGO的使用
         */
        for (int i = 0; i < self.images.count; i ++) {
            //创建EGOImageView 对象
            EGOImageView * imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, 200)];
            //设置空白图片
            imageView.placeholderImage = [UIImage imageNamed:@"photo"];
            //设置EGOImageView 的图片URL ，  它会自动异步去下载图片，并且会缓存
            imageView.imageURL = [self.images objectAtIndex:i];
            [self.scrollView addSubview:imageView];
        }
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    //    NSLog(@"%@",request.error);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

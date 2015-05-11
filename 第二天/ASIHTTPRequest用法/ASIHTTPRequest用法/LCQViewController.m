//
//  LCQViewController.m
//  ASIHTTPRequest用法
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "ASINetworkQueue.h"

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
    
    //创建一个ASIHTTPRequest
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:scrollURL];
    //设置代理
    request.delegate = self;
    //设置标记
    request.tag = 1;
    //请求  同步执行     异步（startAsynchronous）
    [request startSynchronous];
    
}
//请求代理方法（请求结束）
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1) {
        //request.responseData   请求返回的数据
        NSArray * imagesArray = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary * dict in imagesArray) {
            NSURL * imageURL = [NSURL URLWithString:[dict objectForKey:@"Pic"]];
            [self.images addObject:imageURL];
        }
        
        self.scrollView.contentSize = CGSizeMake(self.images.count * 320, 0);
        for (int i = 0; i < self.images.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(320 * i, 0 , 320, 200);
            imageView.image = [UIImage imageNamed:@"photo"];
            imageView.tag = 10+i;
            [self.scrollView addSubview:imageView];
            
        }
        //创建 ASINetworkQueue 的网络队列
        ASINetworkQueue * queue = [[ASINetworkQueue alloc] init];
        for (int i = 0; i < self.images.count; i ++) {
            ASIHTTPRequest * requset = [ASIHTTPRequest requestWithURL:[self.images objectAtIndex:i]];
            requset.delegate = self;
            requset.tag = 10 +i;
            
            //            把请求对象加到线程池中
            [queue addOperation:requset];
        }
        //开始执行队列中的请求
        [queue go];
    }else{
        UIImageView * imageView = (UIImageView *)[self.scrollView viewWithTag:request.tag];
        imageView.image =[UIImage imageWithData:request.responseData];
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

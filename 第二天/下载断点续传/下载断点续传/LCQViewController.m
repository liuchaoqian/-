//
//  LCQViewController.m
//  下载断点续传
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface LCQViewController ()<ASIHTTPRequestDelegate,ASIProgressDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) ASIHTTPRequest * request;
@property (strong, nonatomic) ASINetworkQueue * queue;

@end

@implementation LCQViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    _queue = [[ASINetworkQueue alloc] init];
    [_queue reset];
    _queue.showAccurateProgress = YES;
    [_queue go];
    
}
//点击开始下载按钮
- (IBAction)startDownload:(UIButton *)sender {
    
    NSURL * url = [NSURL URLWithString:@"http://mp3downb.111ttt.com/2011/myxc/20110126/507.mp4"];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    self.request.delegate = self;
    //设置下载进度代理
    self.request.downloadProgressDelegate = self;
    //获取家目录
    NSString * path = NSHomeDirectory();
    //设置存储路径
    NSString * savePath = [path stringByAppendingPathComponent:@"qgw.mp4"];
    //设置临时路径
    NSString * temp = [path stringByAppendingPathComponent:@"temp"];
    //设置文件临时存储路径
    NSString * tempPath = [temp stringByAppendingPathComponent:@"qgw.mp4"];
    
    NSFileManager * fm = [NSFileManager defaultManager];
    //判断临时目录是否存在
    if (![fm fileExistsAtPath:temp]) {
        //不存在就创建一个临时路径
        [fm createDirectoryAtPath:temp withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //设置下载目录
    [self.request setDownloadDestinationPath:savePath];
    //设置临时下载目录
    [self.request setTemporaryFileDownloadPath:tempPath];
    //允许断点下载文件
    self.request.allowResumeForFileDownloads = YES;
    
//    _progressView.progress = 0.0;
    //将请求添加到队列中
    [_queue addOperation:self.request];
}
//点击暂停下载按钮
- (IBAction)stopDownload:(UIButton *)sender {
    //清除代理并退出
    [_request clearDelegatesAndCancel];
}
//代理方法   下载进度改变
- (void)setProgress:(float)newProgress{
    [_progressView setProgress:newProgress];//赋给进度条
    //    NSLog(@"progress=%lf",newProgress);
    if (newProgress == 1.0) {
//        self.stopButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

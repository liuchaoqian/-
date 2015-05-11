//
//  LCQAppDelegate.m
//  异步网络请求
//
//  Created by qf on 15/5/5.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQAppDelegate.h"

@implementation LCQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    NSURLConnection    网络请求类，
//    NSURLRequest          网络请求参数类（请求超时...）
    NSURL * imageUrl  = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D400/sign=28f889676d061d957d4636384bf50a5d/6a63f6246b600c3306bd2e97194c510fd8f9a1ad.jpg"];
//    NSURLRequest * urlRequest1 = [[NSURLRequest alloc] initWithURL:imageUrl];
    NSURLRequest * urlRequest2 = [[NSURLRequest alloc] initWithURL:imageUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLConnection * urlCon = [[NSURLConnection alloc] initWithRequest:urlRequest2 delegate:self];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 400)];
    [self.window addSubview:_imageView];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
float time1 = 0.0;
-(void)timerAction
{
    time1 += 0.001;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    
    long long length = [response expectedContentLength];
    NSLog(@"%lld", length);
    
    NSString * fileType = [response MIMEType];
    NSLog(@"%@", fileType);
    
    NSString * fileName = [response suggestedFilename];
    NSLog(@"%@", fileName);
    
}
float i = 0.0;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    float s = data.length / 1024.0 / 8 / (time1 - i) ;
    NSLog(@"速度：%.1fKb/s",s);
    [_data appendData:data];
    i = time1;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage * image = [UIImage imageWithData:_data];
    _imageView.image = image;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

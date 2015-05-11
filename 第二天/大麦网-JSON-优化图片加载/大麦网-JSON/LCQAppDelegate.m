//
//  LCQAppDelegate.m
//  大麦网-JSON
//
//  Created by qf on 15/5/5.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQAppDelegate.h"
#import "RootViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@implementation LCQAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController * vc1 = [[RootViewController alloc] init];
    UINavigationController * nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    //保持图片原来的颜色
    UITabBarItem * tab1 = [[UITabBarItem alloc] initWithTitle:@"推荐" image:[[UIImage imageNamed:@"btnMain.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"btnMain_on.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc1.tabBarItem = tab1;
    
    SecondViewController * vc2 = [[SecondViewController alloc] init];
    UINavigationController * nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UITabBarItem * tab2 = [[UITabBarItem alloc] initWithTitle:@"分类" image:[[UIImage imageNamed:@"btnShop.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"btnShop_on.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc2.tabBarItem = tab2;
    
    ThirdViewController * vc3 = [[ThirdViewController alloc] init];
    UINavigationController * nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UITabBarItem * tab3 = [[UITabBarItem alloc] initWithTitle:@"我的大麦" image:[UIImage imageNamed:@"btnUser.png"] selectedImage:[UIImage imageNamed:@"btnUser_on.png"]];
    vc3.tabBarItem = tab3;
    
    FourthViewController * vc4 = [[FourthViewController alloc] init];
    UINavigationController * nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UITabBarItem * tab4 = [[UITabBarItem alloc] initWithTitle:@"更多" image:[[UIImage imageNamed:@"btnMore.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"btnMore_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    vc4.tabBarItem = tab4;
    
    NSArray * array = @[nc1,nc2,nc3,nc4];
    UITabBarController * tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = array;
    tbc.tabBar.backgroundImage = [UIImage imageNamed:@"底部.png"];
    tbc.tabBar.barTintColor = [UIColor greenColor];
    tbc.tabBar.selectedImageTintColor = [UIColor colorWithRed:200 / 255.0 green:114 / 255.0 blue:128 / 255.0 alpha:1];
    
    //修改标题文字的颜色
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeFont : [UIFont systemFontOfSize:12],UITextAttributeTextColor : [UIColor colorWithRed:0.5 green:0 blue:0 alpha:1]} forState:UIControlStateNormal];
    self.window.rootViewController = tbc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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

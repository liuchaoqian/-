//
//  ViewController.m
//  满座网
//
//  Created by qf on 15/4/26.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FirstViewController * vc1 = [[FirstViewController alloc] init];
    UINavigationController * nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UITabBarItem * item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"main.png"] selectedImage:[UIImage imageNamed:@"main.png"]];
    nc1.tabBarItem = item1;
    SecondViewController * vc2 = [[SecondViewController alloc] init];
    UINavigationController * nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UITabBarItem * item2 = [[UITabBarItem alloc] initWithTitle:@"周边" image:[UIImage imageNamed:@"around@2x.png"] selectedImage:[UIImage imageNamed:@"around@2x.png"]];
    nc2.tabBarItem = item2;
    ThirdViewController * vc3 = [[ThirdViewController alloc] init];
    UINavigationController * nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UITabBarItem * item3 = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"search.png"] selectedImage:[UIImage imageNamed:@"search.png"]];
    nc3.tabBarItem = item3;
    FourthViewController * vc4 = [[FourthViewController alloc] init];
    UINavigationController * nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UITabBarItem * item4 = [[UITabBarItem alloc] initWithTitle:@"我的满座" image:[UIImage imageNamed:@"myManzuo.png"] selectedImage:[UIImage imageNamed:@"myManzuo.png"]];
    nc4.tabBarItem = item4;
    
    NSArray * array = [NSArray arrayWithObjects:nc1,nc2,nc3,nc4, nil];
    self.viewControllers = array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

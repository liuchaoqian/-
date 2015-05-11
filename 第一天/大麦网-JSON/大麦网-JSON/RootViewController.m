//
//  RootViewController.m
//  大麦网
//
//  Created by qf on 15/4/23.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "RootViewController.h"
#import "LCQTableViewCell.h"

@interface RootViewController ()
@property (strong, nonatomic) NSOperationQueue * queue;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(UIScrollView *)getScrollView
//{
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//        [self.view addSubview:_scrollView];
//    }
//    return _scrollView;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _queue = [[NSOperationQueue alloc] init];
    
    self.navigationItem.title = @"推荐";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"背景.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 36)];
    leftButton.tag = 10001;
    [leftButton setTitle:@"全国" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"城市选择.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"城市选择点击.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(dropdownlist:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 39)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"日历.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"日历点击.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    
    NSURL * scrollURL = [NSURL URLWithString:@"http://mapi.damai.cn/hot201303/nindex.aspx?cityid=0&source=10099&version=30602"];
    NSURLRequest * scrollReqest = [[NSURLRequest alloc] initWithURL:scrollURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    NSURLConnection * scrollConnection = [[NSURLConnection alloc] initWithRequest:scrollReqest delegate:self];
    
    
    NSArray * array = @[@"推荐",@"话剧榜",@"摇滚榜",@"热门榜"];
    UIImage * img = [UIImage imageNamed:@"标签背景.png"];
    UIImage * img1 = [UIImage imageNamed:@"首页选中.png"];

    for (int i = 0; i < 4; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 80, 100, 80, 35);
        [button setTitle:[array objectAtIndex: i] forState:UIControlStateNormal];
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setBackgroundImage:img1 forState:UIControlStateSelected];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tag = 1000 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [self.view addSubview:button];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, 227) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"LCQTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    NSURL * tableURL = [NSURL URLWithString:@"http://mapi.damai.cn/proj/HotProj.aspx?CityId=0&source=10099&version=30602"];
    NSURLRequest * tableReqest = [[NSURLRequest alloc] initWithURL:tableURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    _tableConnection = [[NSURLConnection alloc] initWithRequest:tableReqest delegate:self];
    
    _cityDateArray = [[NSMutableArray alloc] initWithObjects:@"全国",@"北京",@"上海",@"广州",@"湖南",@"云南",@"西藏", nil];
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == _tableConnection) {
        _tableDate = [[NSMutableData alloc] init];
        _dateArray = [[NSMutableArray alloc] init];
    }else{
        _scrollData = [[NSMutableData alloc] init];
        _scrollArray = [[NSMutableArray alloc] init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == _tableConnection) {
        [_tableDate appendData:data];
    }else{
        [_scrollData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == _tableConnection) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:_tableDate options:NSJSONReadingAllowFragments error:nil];
        _dateArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"list"]];
        [_tableView reloadData];
    }else{
        NSArray * array = [NSJSONSerialization JSONObjectWithData:_scrollData options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary * dict in array) {
            [_scrollArray addObject:[dict objectForKey:@"Pic"]];
        }
        self.scrollView.contentSize = CGSizeMake(320 * _scrollArray.count, 100);
        
        for (int i = 0 ; i < _scrollArray.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 100)];
            [self.scrollView addSubview:imageView];
            NSURL * url =[NSURL URLWithString:[_scrollArray objectAtIndex:i]];
            
            [_queue addOperationWithBlock:^{
                NSData * data = [NSData dataWithContentsOfURL:url];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imageView.image = [UIImage imageWithData:data];
                }];
            }];

            
        }
    }
}

//-(void)downloadImage:(NSURL *)url
//{
//    NSLog(@"%@", [NSThread currentThread]);
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    UIImageView * imageView = [self.scrollView.subviews objectAtIndex:[[NSThread currentThread].name intValue]];
//    imageView.image = [UIImage imageWithData:data];
//}

-(void)dropdownlist:(UIButton *)button{
    if (button.selected) {
        UITableView * tableView = (UITableView *)[self.navigationController.view viewWithTag:10000];
        [tableView removeFromSuperview];
        button.selected = NO;
    }else{
        UITableView * cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 60, 70, 100) style:UITableViewStylePlain];
        cityTableView.delegate = self;
        cityTableView.dataSource = self;
        cityTableView.tag = 10000;
        cityTableView.rowHeight = 20;
        cityTableView.backgroundColor = [UIColor orangeColor];
        cityTableView.showsVerticalScrollIndicator = NO;
        [self.navigationController.view addSubview:cityTableView];
        button.selected = YES;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10000) {
        NSString * city = [_cityDateArray objectAtIndex:indexPath.row];
        UIButton * button = (UIButton *)[self.navigationController.view viewWithTag:10001];
        [button setTitle:city forState:UIControlStateNormal];
        UITableView * tableView = (UITableView *)[self.navigationController.view viewWithTag:10000];
        [tableView removeFromSuperview];
        button.selected = NO;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (tableView == _tableView) {
        __strong NSMutableArray * array1 = [_dateArray objectAtIndex:sourceIndexPath.row];
        [_dateArray removeObjectAtIndex:sourceIndexPath.row];
        [_dateArray insertObject:array1 atIndex:destinationIndexPath.row];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10000) {
        return _cityDateArray.count;
    }else{
        return _dateArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag != 10000) {
        static NSString * cellID = @"cell";
        LCQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LCQTableViewCell" owner:nil options:nil] lastObject];
        }
        NSDictionary * dict = [_dateArray objectAtIndex:indexPath.row];
        
        [cell setCellData:dict];

        return cell;
    }else{
        static NSString * cityCellID = @"cityCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cityCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellID];
        }
        cell.textLabel.text = [_cityDateArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor orangeColor];
        return cell;
    }
}
-(void)buttonClick:(UIButton *)button{
    for (int i = 0; i < 4; i ++) {
        UIButton * button1 = (UIButton *)[self.view viewWithTag:1000 + i];
        button1.selected = NO;
    }
    button.selected = YES;
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

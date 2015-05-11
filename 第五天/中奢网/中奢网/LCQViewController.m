//
//  LCQViewController.m
//  中奢网
//
//  Created by qf on 15/5/8.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "GDataXMLNode.h"
#import "UIImageView+WebCache.h"
#import "ASIHttpRequst/ASIHTTPRequest.h"
#import "LCQTableViewCell.h"
#import "LCQNews.h"
#import "MJRefresh/MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "Reachability.h"
#import "FMDatabase.h"
#import "MBProgressHUD.h"

@interface LCQViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    Reachability * hostReach;//网络状态
    NetworkStatus netstatus;
    BOOL isConnected;//判断是否已经连接
}
@property (strong, nonatomic) UIScrollView * topScrollView;
@property (strong, nonatomic) UIImageView * addImageView;
@property (strong, nonatomic) UILabel * addLabel;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * tableData;
@property (assign, nonatomic) int pindex;
@property (assign, nonatomic) int catid;
@property (strong, nonatomic) MJRefreshHeaderView * refreshHead;
@property (strong, nonatomic) MJRefreshFooterView * refreshFoot;
@property (strong, nonatomic) UIScrollView * footScrollView;
@property (strong, nonatomic) FMDatabase * dataBase;
@property (strong, nonatomic) MBProgressHUD * progressHUD;
@end

@implementation LCQViewController

#pragma mark - 属性懒加载
-(UIScrollView *)topScrollView
{
    if (_topScrollView == nil) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
//        _topScrollView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topScrollView;
}
-(UIImageView *)addImageView
{
    if (_addImageView == nil) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 120)];
    }
    return _addImageView;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 480 - 180 - 35) style:UITableViewStylePlain];
    }
    return _tableView;
}
-(UIScrollView *)footScrollView
{
    if (_footScrollView == nil) {
        _footScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 480 - 35, self.view.frame.size.width, 35)];
    }
    return _footScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];

    self.catid = 0;
    self.pindex = 1;
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    logoImageView.image = [UIImage imageNamed:@"top-logo"];
    [self.view addSubview:logoImageView];
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    bgImageView.image = [UIImage imageNamed:@"top-nav"];
    [self.view addSubview:bgImageView];
    
    [self initNavigation];
    
    [self initAddImageView];
    
    [self.view addSubview:self.tableView];
    _tableData = [[NSMutableArray alloc] init];
//    [self initTableView];
    
    [self initFootView];
    
    _refreshHead = [[MJRefreshHeaderView alloc] initWithScrollView:self.tableView];
    _refreshHead.delegate = self;
    _refreshFoot = [[MJRefreshFooterView alloc] initWithScrollView:self.tableView];
    _refreshFoot.delegate = self;
    
}
#pragma mark - 启用网络监视
-(void)reachabilityChanged:(NSNotification *)note{
    
    NSString * connectionKind = nil;
    
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    netstatus = [curReach currentReachabilityStatus];
    switch (netstatus) {
        case NotReachable:
            connectionKind = @"当前没有网络链接\n请检查你的网络设置";
            
            isConnected =NO;
        {
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.rowHeight = 80;
            self.tableView.showsVerticalScrollIndicator = NO;
            [self.tableView registerNib:[UINib nibWithNibName:@"LCQTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        }
        {
            [_tableData removeAllObjects];
            NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            _dataBase = [FMDatabase databaseWithPath:[path stringByAppendingString:@"/my.db"]];
            NSFileManager * fm = [NSFileManager defaultManager];
            BOOL exists = [fm fileExistsAtPath:[path stringByAppendingString:@"/my.db"]];
            if (exists) {
                [_dataBase open];
                NSString * sql = @"select * from myData";
                FMResultSet * result = [_dataBase executeQuery:sql];
                while(result.next) {
                    LCQNews * news = [[LCQNews alloc] init];
                    news.name = [result stringForColumn:@"title"];
                    news.introduce = [result stringForColumn:@"detail"];
                    news.surl = [result stringForColumn:@"imageURL"];
                    
                    [_tableData addObject:news];
                }
                NSLog(@"当前没有网络链接\n请检查你的网络设置");
                [self.tableView reloadData];
            }
        }

                    break;
            
        case ReachableViaWiFi:
            connectionKind = @"当前使用的网络类型是WIFI";
            isConnected =YES;
            NSLog(@"当前使用的网络类型是WIFI");
            [self initTableView];
            break;
            
        case ReachableViaWWAN:
            connectionKind = @"您现在使用的是2G/3G网络\n可能会产生流量费用";
            isConnected =YES;
            NSLog(@"您现在使用的是2G/3G网络\n可能会产生流量费用");
            [self initTableView];
            break;
            
        default:
            break;
    }
}

#pragma mark - 下拉、上拖刷新
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _refreshHead) {
        self.pindex = 1;
    }else{
        self.pindex += 1;
    }
    
    NSURL * tableURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://act.chinaluxus.com/ios/articleHandler.ashx?type=arts&mtype=0&psize=10&catid=%d&pindex=%d", self.catid, self.pindex]];
    [self createASIHTTPRequestWithURL:tableURL IsneedRemove:NO];
}
#pragma mark - 创建表格数据请求
-(void)createASIHTTPRequestWithURL:(NSURL *)url IsneedRemove:(BOOL)remove
{
    ASIHTTPRequest * tableRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    tableRequest.delegate = self;
    tableRequest.timeOutSeconds = 60;
    tableRequest.tag = 100;
    if (remove) {
        [_tableData removeAllObjects];
    }
    _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHUD.labelText = @"正在加载...";
    _progressHUD.detailsLabelText = @"请稍后";
    _progressHUD.yOffset = 70;
    _progressHUD.opacity = 0.4;
    
    [tableRequest startAsynchronous];
}
/**
 *  数据请求完成
 *
 *  @param request 代理方法
 */
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSData * data = request.responseData;
    GDataXMLDocument * addXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    if (addXML) {
        if (request.tag == 100) {
            //当下拉刷新时，要清空表格数据
            if (_refreshHead.isRefreshing) {
                [_refreshHead endRefreshing];
                [_tableData removeAllObjects];
            }
            [_refreshFoot endRefreshing];
    
            if (self.catid == 0 && self.pindex == 1) {
                NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                _dataBase = [FMDatabase databaseWithPath:[path stringByAppendingString:@"/my.db"]];
                NSFileManager * fm = [NSFileManager defaultManager];
                BOOL exists = [fm fileExistsAtPath:[path stringByAppendingString:@"/my.db"]];
                    [_dataBase open];
                if (exists) {
                    NSString * sq = @"delete from myData";
                    [_dataBase executeUpdate:sq];
                }
                    NSString * sql = @"create table if not exists myData (title text, detail text,imageURL text)";
                    if ([_dataBase executeUpdate:sql]) {
                        NSString * sql = @"insert into myData(title,detail,imageURL) values(?,?,?)";
                        
                        NSArray * tableArray = [addXML nodesForXPath:@"//resource" error:nil];
                        for (GDataXMLElement * element in tableArray) {
                            LCQNews * news = [[LCQNews alloc] init];
                            news.name = [[element elementsForName:@"name"][0] stringValue];
                            news.introduce = [[element elementsForName:@"introduce"][0] stringValue];
                            news.surl = [[element elementsForName:@"surl"][0] stringValue];
                            
                            [_dataBase executeUpdate:sql, news.name, news.introduce, news.surl];
                            
                            [_tableData addObject:news];
                        }
//                        NSLog(@"bbbb");
                    }
                self.tableView.scrollEnabled = YES;
                [self.tableView reloadData];
                
                [_progressHUD hide:YES];
                return;
            }
            else {
//            GDataXMLElement * rootElement = [addXML rootElement];
//            NSLog(@"%@", rootElement);
                NSArray * tableArray = [addXML nodesForXPath:@"//resource" error:nil];
                for (GDataXMLElement * element in tableArray) {
                    LCQNews * news = [[LCQNews alloc] init];
                    news.name = [[element elementsForName:@"name"][0] stringValue];
                    news.introduce = [[element elementsForName:@"introduce"][0] stringValue];
                    news.surl = [[element elementsForName:@"surl"][0] stringValue];
                    [_tableData addObject:news];
                }
                
                self.tableView.scrollEnabled = YES;
                [self.tableView reloadData];
                [_progressHUD hide:YES];
            }
        }else{
//            GDataXMLElement * rootElement = [addXML rootElement];
        _addLabel.text = [[addXML nodesForXPath:@"//desc" error:nil][0] stringValue];
        NSString * addImage = [[addXML nodesForXPath:@"//src" error:nil][0] stringValue];
        
        [self.addImageView setImageWithURL:[NSURL URLWithString:addImage] placeholderImage:[UIImage imageNamed:@"photo"]];
        }
    }
}
#pragma mark - 滚动导航
/**
 *  初始化滚动导航
 */
-(void)initNavigation
{
    NSArray * channelArray = [[NSMutableArray alloc] initWithObjects:@"聚焦",@"视野",@"驾驭",@"腕表",@"地产",@"时尚",@"环保",@"旅游",@"美食",@"运动",@"艺术",@"健康",@"收藏", @"中奢访谈",nil];
    NSArray * IDArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"206",@"3",@"4",@"101",@"5",@"6",@"129",@"148",@"7",@"8",@"999", nil];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    self.topScrollView.contentSize = CGSizeMake(50 * channelArray.count + 20, 40);
    for (int i = 0; i < channelArray.count; i ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * 50 + 10, 10, 50, 20)];
        if (i == 0) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor grayColor]];
        }
        button.tag = [[IDArray objectAtIndex:i] integerValue];
        [button setTitle:[channelArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"top-nav-item"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        [button setTitleShadowColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget: self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:button];
    }
}
#pragma mark - 导航点击事件
-(void)buttonAction:(UIButton *)button
{
    for (UIView * view in self.topScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)view;
            button.selected = NO;
            [button setBackgroundColor:[UIColor clearColor]];
        }
    }
    button.selected = YES;
    [button setBackgroundColor:[UIColor grayColor]];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://act.chinaluxus.com/ios/articleHandler.ashx?type=focus&catid=%d", button.tag]];
    ASIHTTPRequest * addRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    addRequest.delegate = self;
    [addRequest startAsynchronous];
    
    self.catid = button.tag;
    self.pindex = 1;
    NSURL * tableURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://act.chinaluxus.com/ios/articleHandler.ashx?type=arts&mtype=0&psize=10&catid=%d&pindex=%d", self.catid, self.pindex]];
    self.tableView.scrollEnabled = NO;
    [self createASIHTTPRequestWithURL:tableURL IsneedRemove:YES];
}
#pragma mark - 广告区初始化
-(void)initAddImageView
{
    [self.view addSubview:self.addImageView];
    self.addImageView.image = [UIImage imageNamed:@"photo"];
    _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20)];
    _addLabel.backgroundColor = [UIColor grayColor];
    _addLabel.alpha = 0.7;
    _addLabel.font = [UIFont systemFontOfSize:12];
    _addLabel.textAlignment = NSTextAlignmentCenter;
    [self.addImageView addSubview:_addLabel];
    
    NSURL * url = [[NSURL alloc] initWithString:@"http://act.chinaluxus.com/ios/articleHandler.ashx?type=focus&catid=0"];
    ASIHTTPRequest * addRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    addRequest.delegate = self;
    [addRequest startAsynchronous];
}

#pragma mark - 初始化表格
/**
 *  初始化表格数据
 */
-(void)initTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"LCQTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://act.chinaluxus.com/ios/articleHandler.ashx?type=arts&mtype=0&psize=10&catid=0&pindex=1"]];
    [self createASIHTTPRequestWithURL:url IsneedRemove:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    LCQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LCQTableViewCell" owner:nil options:nil][0];
    }
    cell.titleLabel.text = [[_tableData objectAtIndex:indexPath.row] name];
    cell.detailLabel.text = [[_tableData objectAtIndex:indexPath.row] introduce];
    [cell.iconView setImageWithURL:[NSURL URLWithString: [[_tableData objectAtIndex:indexPath.row] surl]] placeholderImage:[UIImage imageNamed:@"photo"]];
    
    return cell;
}
#pragma mark - 初始化底部滚动视图
-(void)initFootView
{
    NSArray * channelArray = [[NSMutableArray alloc] initWithObjects:@"聚焦",@"视野",@"驾驭",@"腕表",@"地产",@"时尚",@"环保",@"旅游",@"美食",@"运动",@"艺术",@"健康",@"收藏", @"中奢访谈",nil];
    NSArray * IDArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"206",@"3",@"4",@"101",@"5",@"6",@"129",@"148",@"7",@"8",@"999", nil];
    self.footScrollView.showsHorizontalScrollIndicator = NO;
    self.footScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.footScrollView];
    self.footScrollView.contentSize = CGSizeMake(60 * channelArray.count, 35);

    for (int i = 0; i < channelArray.count; i ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * 60 , 5, 60, 25)];
        
        button.tag = [[IDArray objectAtIndex:i] integerValue];
        [button setTitle:[channelArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ft-nav-hover"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//        [button addTarget: self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.footScrollView addSubview:button];
    }

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

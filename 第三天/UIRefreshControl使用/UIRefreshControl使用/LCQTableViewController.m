//
//  LCQTableViewController.m
//  UIRefreshControl使用
//
//  Created by qf on 15/5/8.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQTableViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "GDataXMLNode.h"

@interface LCQTableViewController ()<ASIHTTPRequestDelegate>
{
    UIRefreshControl * _refreshControl;
    
    //缓冲区
    NSMutableData * _downloadData;
    
    //数据源
    NSMutableArray * _newsArray;
}

@end

@implementation LCQTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    _refreshControl.tintColor = [UIColor greenColor];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]  initWithString:@"正在刷新"];
    [_refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _downloadData = [[NSMutableData alloc] init];
    _newsArray = [[NSMutableArray alloc] init];
    
    [self requestData];
    
    
}
//refreshControl事件方法
- (void)reload
{
    NSLog(@"开始刷新");
    
    //删除原来旧的数据
    [_newsArray removeAllObjects];
    
    //请求服务器最新数据
    [self requestData];
    
    //延迟操作
    //[self performSelector:@selector(stop) withObject:nil afterDelay:3];
}
-(void)requestData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载...";
    hud.detailsLabelText = @"请稍后";
    
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://rss.sina.com.cn/roll/sports/hot_roll.xml"]];
    request.delegate = self;
    [request startSynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    _downloadData.length = 0;
    [_downloadData appendData:request.responseData];
    [_refreshControl endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    GDataXMLDocument * document = [[GDataXMLDocument alloc] initWithData:_downloadData options:0 error:nil];
    NSArray *news = [document nodesForXPath:@"/rss/channel/item" error:nil];
    
    //遍历所有的item
    for (GDataXMLElement *element in news)
    {
        GDataXMLElement *titleElement = [element elementsForName:@"title"][0];
        NSLog(@"%@",[titleElement stringValue]);
        
        //添加到数据
        [_newsArray addObject:[titleElement stringValue]];
    }
    
    //刷新
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _newsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_newsArray.count > 0)
    {
        cell.textLabel.text = _newsArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

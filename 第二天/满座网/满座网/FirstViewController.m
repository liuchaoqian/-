//
//  FirstViewController.m
//  满座网
//
//  Created by qf on 15/4/26.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "FirstViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ASIHTTPRequest.h"
//#import "ASINetworkQueue.h"
#import "UIImageView+WebCache.h"
#import "GDataXMLNode.h"
#import "ItemInfo.h"

@interface FirstViewController ()<ASIHTTPRequestDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UIPageControl * pageControl;
@end

@implementation FirstViewController

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
    [self initNavigationBar];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    _scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    [self initData];
    
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 160, 39)];
    [_allButton setBackgroundImage:[UIImage imageNamed:@"leftDrop_bg_selected.png"] forState:UIControlStateSelected];
    [_allButton setBackgroundImage:[UIImage imageNamed:@"leftDrop_bg_press.png"] forState:UIControlStateHighlighted];
    [_allButton setBackgroundImage:[UIImage imageNamed:@"leftDrop_bg.png"] forState:UIControlStateNormal];
    [_allButton setBackgroundImage:[UIImage imageNamed:@"leftDrop_bg_disable.png"] forState:UIControlStateDisabled];
    [_allButton setTitle:@"全部" forState:UIControlStateNormal];
    [_allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allButton setImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
    [self.view addSubview:_allButton];
    _sortButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 120, 160, 39)];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"rightDrop_bg_selected.png"] forState:UIControlStateSelected];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"rightDrop_bg_press.png"] forState:UIControlStateHighlighted];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"rightDrop_bg_disable.png"] forState:UIControlStateDisabled];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"rightDrop_bg.png"] forState:UIControlStateNormal];
    [_sortButton setTitle:@"人气最高" forState:UIControlStateNormal];
    [_sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sortButton setImage:[UIImage imageNamed:@"sort.png"] forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sortButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 159, 320, 480 - 64 - 39 - 49 - 120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 140;
    [self.view addSubview:_tableView];
    
}

/**
 *      加载数据
 */
-(void)initData{
    _addressArray = [NSMutableArray arrayWithObjects:@"北京",@"上海",@"广州",@"南京",@"湖南",@"海南", nil];
    _sortArray = [NSMutableArray arrayWithObjects:@"人气最高",@"价格最高", nil];
//    _dataArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data.plist" ofType:nil]];
    //获取表格数据
    _dataArray = [[NSMutableArray alloc] init];
    NSURL * tableURL = [[NSURL alloc] initWithString:@"http://mps.manzuo.com/mps/cate?sid=(null)&id=0&cc=beijing&pt=all&ffst=1&mnt=10&st=-1&hs=1"];
    ASIHTTPRequest * tableRequest = [[ASIHTTPRequest alloc] initWithURL:tableURL];
    //设置超时时间
    tableRequest.timeOutSeconds = 60;
    tableRequest.tag = 2;
    tableRequest.delegate = self;
    [tableRequest startAsynchronous];
    
    //获取滚动栏数据
    _scrollArray = [[NSMutableArray alloc] init];
    NSURL * scrollURL = [[NSURL alloc] initWithString:@"http://mp.manzuo.com/china/beijing/home_2.xml"];
    ASIHTTPRequest * scrollRequest = [[ASIHTTPRequest alloc] initWithURL:scrollURL];
    scrollRequest.timeOutSeconds = 30;
    scrollRequest.tag = 1;
    scrollRequest.delegate = self;
    [scrollRequest startAsynchronous];
}
/**
 *  ASIHTTPRequest的代理方法，请求完成执行
 *
 *  @param request 获取XML数据
 */
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1) {
        NSData * data = request.responseData;
        GDataXMLDocument * gXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (gXML) {
            NSArray *array = [gXML nodesForXPath:@"//img" error:nil];
            for (GDataXMLElement *element in array) {
                NSString * str = [element stringValue];
                [_scrollArray addObject:str];
            }
//            NSLog(@"%d", _scrollArray.count);
            _scrollView.contentSize = CGSizeMake(320 * _scrollArray.count, 120);
            UIImageView * imageView = [[UIImageView alloc] init];
            for (int i = 0; i < _scrollArray.count; i ++) {
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 120)];
                imageView.tag = 10 + i;
                imageView.image = [UIImage imageNamed:@"photo"];
                [imageView setImageWithURL:[NSURL URLWithString:[_scrollArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"photo"]];
                [_scrollView addSubview:imageView];
            }
            
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 100, 120, 20)];
            _pageControl.numberOfPages = _scrollArray.count;
            _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            [self.view addSubview:_pageControl];
        }
    }
//    else if (request.tag >= 10){
//        UIImageView * imageView = (UIImageView *)[_scrollView viewWithTag:request.tag];
//        imageView.image = [UIImage imageWithData:request.responseData];
//    }
    else{
        NSData * data = request.responseData;
        GDataXMLDocument * gXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (gXML) {
            GDataXMLElement * root = [gXML rootElement];
            NSLog(@"%@",root);
            NSArray *array = [gXML nodesForXPath:@"//promotion" error:nil];
            for (GDataXMLElement *element in array) {
                ItemInfo * itemInfo = [[ItemInfo alloc] init];
                itemInfo.name = [[[element elementsForName:@"name"] firstObject] stringValue];
                itemInfo.price = [[[element elementsForName:@"price"] firstObject] stringValue];
                itemInfo.priceoff = [[[element elementsForName:@"priceoff"] firstObject] stringValue];
                itemInfo.ID = [[[element elementsForName:@"id"] firstObject] stringValue];
                 itemInfo.district = [[[element elementsForName:@"district"] firstObject] stringValue];
                itemInfo.wsdimg = [[[element elementsForName:@"wsdimg"] firstObject] stringValue];
                [_dataArray addObject:itemInfo];
                [_tableView reloadData];
            }
        }
    }
}

/**
 *  滑动滚动栏，来改变_pageControl 的当前页
 *
 *  @return void
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        int n = _scrollView.contentOffset.x;
        [UIView animateWithDuration:0.1 animations:^{
            _pageControl.currentPage = n / 320;
        }];
    }
}

//初始化导航栏
-(void)initNavigationBar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_logo.png"]];
    self.navigationItem.titleView = imageView;
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    [leftButton setImage:[UIImage imageNamed:@"shake_btn.png"] forState:UIControlStateNormal];
    [leftButton addTarget: self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    [_rightButton setTitle:@"北京" forState:UIControlStateNormal];
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -66, 0, 0)];
    [_rightButton setImage:[UIImage imageNamed:@"ico_drop.png"] forState:UIControlStateNormal];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
//摇动按钮点击事件
-(void)leftButtonClick:(UIButton *)button{
    //调用震动事件
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
//排序按钮点击事件
-(void)sortButtonClick:(UIButton *)button{
    if (button.selected == NO) {
        button.selected = YES;
        _sorttableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 159, 160, 100) style:UITableViewStylePlain];
        _sorttableView.delegate = self;
        _sorttableView.dataSource = self;
        _sorttableView.rowHeight = 50;
        [self.view addSubview:_sorttableView];
    }
}
//导航栏右侧按钮点击事件
-(void)rightButtonClick:(UIButton *)button{
    if (button.selected == NO) {
        button.selected = YES;
        _addresstableView = [[UITableView alloc] initWithFrame:CGRectMake(220, 64, 80, 150) style:UITableViewStylePlain];
        _addresstableView.delegate = self;
        _addresstableView.dataSource = self;
        _addresstableView.rowHeight = 40;
        [self.navigationController.view addSubview:_addresstableView];
    }
}
#pragma mark - 选中某行触发的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:1003];
        priceLabel.textColor = [UIColor whiteColor];
    }else if (tableView == _sorttableView){
        _sortButton.selected = NO;
        [_sorttableView removeFromSuperview];
        if ([_sortButton.titleLabel.text isEqualToString:[_sortArray objectAtIndex:1]]) {
            if (indexPath.row == 0) {
                [_sortButton setTitle:[_sortArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                [self sort:@"ID"];
                for (int i = 0; i < _dataArray.count; i ++) {
                    [self tableView:_tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }else{
            if (indexPath.row == 1) {
                [_sortButton setTitle:[_sortArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                [self sort:@"priceoff"];
                for (int i = 0; i < _dataArray.count; i ++) {
                    [self tableView:_tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
    }else{
        [_rightButton setTitle:[_addressArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        _rightButton.selected = NO;
        [_addresstableView removeFromSuperview];
    }
}
//取消选中某一行触发的事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:1003];
    priceLabel.textColor = [UIColor lightGrayColor];
}
/**
 *  排序方法
 *
 *  @param  <# description#>
 *
 *  @return <#return value description#>
 */
-(void)sort:(NSString *)str{
    if ([str isEqualToString:@"ID"]) {
        for (int i = 0; i < _dataArray.count - 1; i ++) {
            double a = [[[_dataArray objectAtIndex:i] ID] doubleValue];
            for (int j = i + 1; j < _dataArray.count; j ++) {
                double b = [[[_dataArray objectAtIndex:j] ID] doubleValue];
                if (a < b) {
                    [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    a  = b;
                }
            }
        }
        [_tableView reloadData];
    }else{
        for (int i = 0; i < _dataArray.count - 1; i ++) {
            double a = [[[_dataArray objectAtIndex:i] priceoff] doubleValue];
            for (int j = i + 1; j < _dataArray.count; j ++) {
                double b = [[[_dataArray objectAtIndex:j] priceoff] doubleValue];
                if (a < b) {
                    [_dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    a  = b;
                }
            }
        }
        [_tableView reloadData];
    }
}

//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return _dataArray.count;
    }else if (tableView == _sorttableView){
        return _sortArray.count;
    }else{
        return _addressArray.count;
    }
}
//返回单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        static NSString * cell1 = @"table";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell1];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 110, 100)];
            imageView.tag = 1000;
            //SDWebImage的分类方法
            [imageView setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row] wsdimg]] placeholderImage:[UIImage imageNamed:@"photo"]];
            [cell.contentView addSubview:imageView];
            
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 125, 30)];
            titleLabel.tag = 1001;
            titleLabel.numberOfLines = 2;
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = [[_dataArray objectAtIndex:indexPath.row] name];
            [cell.contentView addSubview:titleLabel];
            
            UILabel * realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 70, 90, 30)];
            realPriceLabel.tag = 1002;
            realPriceLabel.font = [UIFont boldSystemFontOfSize:20];
            realPriceLabel.text = [NSString stringWithFormat:@"￥%@", [[_dataArray objectAtIndex:indexPath.row] priceoff]];
            realPriceLabel.textColor = [UIColor orangeColor];
            [cell.contentView addSubview:realPriceLabel];
            
            UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 70, 90, 30)];
            priceLabel.tag = 1003;
            priceLabel.font = [UIFont systemFontOfSize:20];
            priceLabel.text = [NSString stringWithFormat:@"￥%@", [[_dataArray objectAtIndex:indexPath.row] price]];
            priceLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:priceLabel];
            
            UIImageView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 84, 85, 2)];
            lineView.image = [UIImage imageNamed:@"intro_line@2x.png"];
            [cell.contentView addSubview:lineView];
            
            UIImageView * peopleView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 110, 12, 12)];
            peopleView.image = [UIImage imageNamed:@"ico_peoples.png"];
            [cell.contentView addSubview:peopleView];
            
            UILabel * peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 106, 60, 20)];
            peopleLabel.tag = 1004;
            peopleLabel.font = [UIFont systemFontOfSize:13];
            peopleLabel.text = [NSString stringWithFormat:@"%@人", [[_dataArray objectAtIndex:indexPath.row] ID]];
            peopleLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:peopleLabel];
            
            UIImageView * positionView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 110, 12, 12)];
            positionView.image = [UIImage imageNamed:@"ico_locs.png"];
            [cell.contentView addSubview:positionView];
            
            UILabel * positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 106, 50, 20)];
            positionLabel.tag = 1005;
            positionLabel.font = [UIFont systemFontOfSize:13];
            positionLabel.text = [[_dataArray objectAtIndex:indexPath.row] district];
            positionLabel.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:positionLabel];
            
            UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
            bgView.image = [UIImage imageNamed:@"img_grey.png"];
            cell.backgroundView = bgView;
            
        }
        UIImageView * imageView = (UIImageView *)[cell.contentView viewWithTag:1000];
        [imageView setImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:indexPath.row] wsdimg]] placeholderImage:[UIImage imageNamed:@"photo"]];
        
        UILabel * titleLabel = (UILabel *)[cell.contentView viewWithTag:1001];
        titleLabel.text = [[_dataArray objectAtIndex:indexPath.row] name];
        
        UILabel * realPriceLabel = (UILabel *)[cell.contentView viewWithTag:1002];
        realPriceLabel.text = [NSString stringWithFormat:@"￥%@", [[_dataArray objectAtIndex:indexPath.row] priceoff]];
        
        UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:1003];
        priceLabel.textColor = [UIColor lightGrayColor];
        priceLabel.text = [NSString stringWithFormat:@"￥%@", [[_dataArray objectAtIndex:indexPath.row] price]];
        
        UILabel * peopleLabel = (UILabel *)[cell.contentView viewWithTag:1004];
        peopleLabel.text = [NSString stringWithFormat:@"%@人", [[_dataArray objectAtIndex:indexPath.row] ID]];
        
        UILabel * positionLabel = (UILabel *)[cell.contentView viewWithTag:1005];
        positionLabel.text = [[_dataArray objectAtIndex:indexPath.row] district];
        
        return cell;
    }else if (tableView == _addresstableView){
        static NSString * cell2 = @"address";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell2];
            UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
            bgView.image = [UIImage imageNamed:@"img_grey.png"];
            cell.backgroundView = bgView;
        }
        cell.textLabel.text = [_addressArray objectAtIndex:indexPath.row];
        
        return cell;
    }else if (tableView == _alltableView){
        static NSString * cell3 = @"all";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell3];
        }
        
        return cell;
    }else{
        static NSString * cell4 = @"sort";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell4];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell4];
            UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
            bgView.image = [UIImage imageNamed:@"img_grey.png"];
            cell.backgroundView = bgView;
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [_sortArray objectAtIndex:indexPath.row];
        
        return cell;
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

//
//  LCQViewController.m
//  XML解析
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "LCQCityInfo.h"

//遵从NSXMLParserDelegate
@interface LCQViewController ()<NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableArray * dataArray;
//开始标签
@property (strong, nonatomic) NSString * fromTagFlag;

@end

@implementation LCQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"xml.txt" ofType:nil];
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    //将数据源转换为NSXMLParser
    NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:data];
    //设置代理
    xmlParser.delegate = self;
    //开始解析
    [xmlParser parse];
}
//文档开始读取
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    //一般做初始化存储数据的操作
    _dataArray = [[NSMutableArray alloc] init];
}
//解析标签开始
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // 首先用属性fromTagFlag获取ElementName，供后面使用
    _fromTagFlag = elementName;
    if ([elementName isEqualToString:@"systemConfig"] ){
        LCQCityInfo * cityInfo = [[LCQCityInfo alloc] init];
        [_dataArray addObject:cityInfo];
    }
}
//获取到标签对应的数据
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
     // 剔除获取的文本中空格和换行
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    LCQCityInfo * cityInfo = [_dataArray lastObject];
    if ([_fromTagFlag isEqualToString:@"CityName"] && cityInfo) {
        cityInfo.CityName = string;
    }
    if ([_fromTagFlag isEqualToString:@"CityCode"] && cityInfo) {
        cityInfo.CityCode = string;
    }
    if ([_fromTagFlag isEqualToString:@"ParentCityCode"] && cityInfo) {
        cityInfo.ParentCityCode = string;
    }
    if ([_fromTagFlag isEqualToString:@"areaCode"] && cityInfo) {
        cityInfo.areaCode = string;
    }
    if ([_fromTagFlag isEqualToString:@"AgreementUrl"] && cityInfo) {
        cityInfo.AgreementUrl = string;
    }
}
//解析标签结束
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //标签结束要将开始标签清空，否则会将结束标签误认为是开始标签，造成数据解析错误
    self.fromTagFlag = nil;
}
//文档结束读取
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"%@", _dataArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

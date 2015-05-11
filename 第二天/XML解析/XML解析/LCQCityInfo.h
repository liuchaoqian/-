//
//  LCQCityInfo.h
//  XML解析
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCQCityInfo : NSObject
@property (retain, nonatomic) NSString * CityName;
@property (retain, nonatomic) NSString * CityCode;
@property (retain, nonatomic) NSString * ParentCityCode;
@property (retain, nonatomic) NSString * areaCode;
@property (retain, nonatomic) NSString * AgreementUrl;

@end

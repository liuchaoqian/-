//
//  LCQCityInfo.m
//  XML解析
//
//  Created by qf on 15/5/7.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQCityInfo.h"

@implementation LCQCityInfo

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@--%@--%@--%@--%@", self.CityName, _CityCode, _ParentCityCode, _areaCode, _AgreementUrl];
}
@end

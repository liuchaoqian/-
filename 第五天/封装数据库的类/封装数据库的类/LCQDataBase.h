//
//  LCQDataBase.h
//  封装数据库的类
//
//  Created by qf on 15/5/10.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface LCQDataBase : NSObject
{
    FMDatabase * _dataBase;
}

+(LCQDataBase *)sharedDataBase;
-(NSString *)getDataBasePath;
-(BOOL)insertIntoDataBaseWith:(id)obj;
-(NSArray *)selectAllFromDataBase;
-(BOOL)deleteFromDataBaseWith:(id)obj;
-(BOOL)deleteAll;
-(void)closeDataBase;
@end

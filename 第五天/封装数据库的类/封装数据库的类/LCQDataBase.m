//
//  LCQDataBase.m
//  封装数据库的类
//
//  Created by qf on 15/5/10.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQDataBase.h"


@implementation LCQDataBase

-(id)init
{
    if (self = [super init]) {
        _dataBase = [FMDatabase databaseWithPath:[self getDataBasePath]];
        if (![_dataBase open]) {
            return nil;
        }
        NSString * sql = @"create table if not exists myTable (obj integer primary key autoincrement)";
        if ([_dataBase executeUpdate:sql]) {
            NSLog(@"表格创建成功");
        }else{
            NSLog(@"表格创建失败");
        }
    }
    return self;
}

+(LCQDataBase *)sharedDataBase
{
    static LCQDataBase * lcqDB = nil;
    if (lcqDB == nil) {
        lcqDB = [[LCQDataBase alloc] init];
    }
    return lcqDB;
}

-(NSString *)getDataBasePath
{
    NSString * document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return document;
}

-(BOOL)insertIntoDataBaseWith:(id)obj
{
    if (!obj) {
        return NO;
    }
    NSString * sql = @"insert into myTable (obj) values(?)";
    if ([_dataBase executeUpdate:sql, obj]) {
        return YES;
    }else{
        return NO;
    }
}

-(NSArray *)selectAllFromDataBase
{
    NSString * sql = @"select * from myTable";
    FMResultSet * result = [_dataBase executeQuery:sql];
    NSMutableArray * mArray = [[NSMutableArray alloc] init];
    while (result.next) {
        id obj = [result stringForColumn:@"obj"];
        NSLog(@"%@", obj);
        [mArray addObject:obj];
    }
    return mArray;
}

-(BOOL)deleteAll
{
    NSString * sql = @"delete * from myTable";
    if ([_dataBase executeUpdate:sql]) {
        return YES;
    }
    return NO;
}

-(BOOL)deleteFromDataBaseWith:(id)obj
{
    if (!obj) {
        return NO;
    }
    NSString * sql = @"delete from myTable where obj = ?";
    if ([_dataBase executeUpdate:sql, obj]) {
        return YES;
    }
    return NO;
}

-(void)closeDataBase
{
    if (_dataBase) {
        [_dataBase close];
    }
}

@end


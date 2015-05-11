//
//  LCQViewController.m
//  SQL数据库的使用
//
//  Created by qf on 15/5/9.
//  Copyright (c) 2015年 liuchaoqian. All rights reserved.
//

#import "LCQViewController.h"
#import "FMDatabase.h"

@interface LCQViewController ()
@property (strong, nonatomic) FMDatabase * dataBase;

@end

@implementation LCQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view removeFromSuperview];
    
    
    [self createDataBase];
    [self createUserTable];
//    [self insertUserData];
    [self selectAllUserData:@"liu"];
//    [self deleteUserData:@"ddd"];
//    [self updateUserData:@"ddd" replaceName:@"only"];
    
}
#pragma mark - 获取数据库目录
-(NSString *)getDataBasePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = paths[0];
    return [path stringByAppendingString:@"/my.db"];
}
#pragma mark - 打开数据库
-(void)createDataBase
{
    _dataBase = [FMDatabase databaseWithPath:[self getDataBasePath]];
    if (_dataBase.open) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
}
#pragma mark - 创建用户表
-(void)createUserTable
{
    NSString * sql = @"create table if not exists User (Id integer primary key autoincrement,name text,age integer)";
    BOOL isOK = [_dataBase executeUpdate:sql];
    if (isOK) {
        NSLog(@"创建User表成功");
    }else{
        NSLog(@"创建User表失败");
    }
}
#pragma mark - 插入数据
-(void)insertUserData
{
    NSString * sql = @"insert into User(name,age) values(?,?)";
    [_dataBase executeUpdate:sql,@"ddd",[NSNumber numberWithInt:20]];
}
#pragma mark - 查询数据
-(void)selectAllUserData:(NSString *)name
{
//    NSString * sql = [NSString stringWithFormat:@"select * from User where name = '%@'", name];
    NSString * sql = @"select * from User where name = ?";
    FMResultSet * result = [_dataBase executeQuery:sql, name];
    while (result.next) {
        NSString * name = [result stringForColumn:@"name"];
        NSLog(@"%@", name);
        int age = [[result stringForColumn:@"age"] intValue];
        NSLog(@"%d", age);
    }
}
#pragma mark - 删除数据
-(void)deleteUserData:(NSString *)name
{
    NSString * sql = @"delete from User where name = ?";
//    NSString * sql = [NSString stringWithFormat:@"delete from User where name = '%@'", name];
    [_dataBase executeUpdate:sql, name];
}
#pragma mark - 更新数据
-(void)updateUserData:(NSString *)name replaceName:(NSString *)replaceName
{
    NSString * sql = @"update User set name = ?, age = ? where name = ?";
    [_dataBase executeUpdate:sql, replaceName, [NSNumber numberWithInt:99], name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

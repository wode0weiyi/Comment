//
//  MainDB.m
//  Clue
//
//  Created by 王璇 on 16/2/4.
//  Copyright © 2016年 王璇. All rights reserved.
//

#import "MainDB.h"

#define ClientSQLManager_SQL_Name @"Main"

@implementation MainDB

- (instancetype)init{
    if (self=[super initWithDBname:ClientSQLManager_SQL_Name]) {
        
    }
    return self;
}


//检查数据库中表是否存在，若不存在则新建
- (void)checkDatabaseVersion{
    
    [self beginTransaction];
    
//    /*用户信息表建立*/
//    NSString *sql=@"create table if not exists info_user (userId NSInteger not NULL,nickname text,userName text,password text,mobile text,headerUrl text,gender text,address text,lastLoginTime text)";
    
    
    /*爆料草稿箱*/
    NSString *draftsSql = @"create table if not exists Drafts_Info_t (filePath text not NULL, changeTime text not NULL,searchTime text not NULL,userID NSInteger not NULL,saveType NSInteger not NULL)";
    
    /** 创建单位表 */
    NSString *departmentSql = @"create table if not exists t_company (org_orgId NSInteger not NULL,org_orgName text not NULL,companyName text not NULL,address text,latitude text,longitude text,orgNo text,companyType_id NSInteger,companyType_displayName text,userId NSInteger not NULL)";
    
    /** 创建检查类别标签表 */
    NSString *sql3 = @"create table if not exists t_check_type (userId NSInteger not NULL,count NSInteger not NULL,firstLevelName text, firstLevelId NSInteger,secondLevelName text, secondLevelId NSInteger)";
    
    
//    /*info_system*/
//    NSString *sql4 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS info_system (system_id INTEGER PRIMARY KEY NOT NULL,app_version TEXT NOT NULL,sys_kind TEXT NOT NULL,os_version TEXT NOT NULL,platform TEXT NOT NULL,user_ip TEXT NOT NULL,unique_id TEXT NOT NULL,session_id TEXT NOT NULL,app_down_way TEXT NOT NULL,field1 TEXT,field2 TEXT)"];
    
    BOOL isOK=YES;
   
    isOK=isOK&&[self executeUpdate:draftsSql];
    isOK=isOK&&[self executeUpdate:departmentSql];
    isOK &= [self executeUpdate:sql3];
    
    [self endTransactionWithResult:isOK];
}

@end

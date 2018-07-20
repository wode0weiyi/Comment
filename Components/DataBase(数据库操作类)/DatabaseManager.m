//
//  DatabaseManager.m
//  EagleNetClient
//
//  Created by 王 璇 on 12-12-24.
//  Copyright (c) 2012年 wangxuan. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"

#define LocalPath   @"Local"

@interface DatabaseManager (){
@private
    NSString*   dbname;
    BOOL        openDbOK;
}

@end

@implementation DatabaseManager

+(NSString*)getSafeValueWithDic:(NSDictionary*)rsDic withName:(NSString*)name
{
    NSString *Value = nil;
    
    if ((![rsDic objectForKey:name]) || ([[rsDic objectForKey:name] isKindOfClass:[NSNull class]]))
    {
        
    }
    else
    {
        Value = [NSString stringWithFormat:@"%@",[rsDic objectForKey:name]];
    }
    
    return Value;
}

//+ (id)sharedManager{
//    @synchronized(self) {
//        static dispatch_once_t pred = 0;
//        __strong static id _sharedObject = nil;
//        dispatch_once(&pred, ^{
//            _sharedObject = [[self alloc] init];
//        });
//        return _sharedObject;
//    }
//}

-(id)initWithDBname:(NSString *)dbName
{
    if (self = [super init])
    {
        dbname      = dbName;
        openDbOK  = NO;
        dbFM = [[FMDatabase alloc] initWithPath:[self databasePathWithFileName:dbname]];
        [self openDB];
        [self checkDatabaseVersion];
    }
    
    return self;
}

-(void)dealloc
{
    [dbFM close];
    [dbFM release];
    
    [super dealloc];
}

-(void) openDB
{
    if (![dbFM open])
    {
        //Log(@"ClientSQLManager open Fail");
    }
    else
    {
        openDbOK = YES;
        //Log(@"ClientSQLManager open OK");
    }
}

-(void)closeDB
{
    if (![dbFM close])
    {
        //Log(@"ClientSQLManager close Fail");
    }
    else
    {
        openDbOK = NO;
        //Log(@"ClientSQLManager close OK");
    }
}

//获取数据库数据数量
- (int)getDatabaseNumberBySql:(NSString*)sql{
   
    int count = [dbFM intForQuery:sql];
    return count;
}

//获取数据库沙盒路径
- (NSString *)databasePathWithFileName:(NSString *)fileName{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(
                                                             NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *localPath =[docPath stringByAppendingPathComponent:LocalPath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:localPath]) {
//        [fileManager createDirectoryAtPath:localPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
    
    NSString *databaseLocalPath=[localPath stringByAppendingFormat:@"%@.sql",fileName];
    //沙盒中已存在数据库文件
    if ([fileManager fileExistsAtPath:databaseLocalPath]) {
        return databaseLocalPath;
    }
    
    //bundle中已存在数据库文件
    NSString *bundlePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"sql"];
    if ([fileManager fileExistsAtPath:bundlePath]) {
        [fileManager copyItemAtPath:bundlePath toPath:databaseLocalPath error:nil];
        return databaseLocalPath;
    }
    
    return databaseLocalPath;
}

//检查数据库中表是否存在，若不存在则新建
- (void)checkDatabaseVersion{
    
}

#pragma mark modifyMainSql --
-(BOOL)executeUpdate:(NSString*)sql
{
    @synchronized(self)
    {
        if (!openDbOK)
        {
            [self openDB];
        }
        
        BOOL result = YES;
        NSError *err = 0x00;
        result = [dbFM executeUpdate:sql withErrorAndBindings:&err];
        if (!result) {
            NSLog(@"error = %@", [dbFM lastErrorMessage]);
        }
        return result;
    }
}

-(NSMutableArray*)executeQuery:(NSString*)sql
{
    @synchronized(self)
    {
        if (!openDbOK) {
            [self openDB];
        }
        
        FMResultSet *rs = [dbFM executeQuery:sql];
        
        NSMutableArray *arrTemp = [[NSMutableArray new] autorelease];
        
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        while ([rs next])
        {
            NSDictionary *dicTemp = [[NSDictionary alloc] initWithDictionary:[rs resultDictionary]];
            [arrTemp addObject:dicTemp];
            
            [dicTemp release];
        }
        
        [rs close];
        
        [pool release];
        
        return arrTemp;
    }
}

#pragma mark 批量
-(void)beginTransaction
{
    //[dbFM beginTransaction];
    [dbFM beginDeferredTransaction];
}

-(void)endTransactionWithResult:(BOOL)bResult
{
    if(!bResult)
        [dbFM rollback];
    else
        [dbFM commit];
}

@end


//
//  DatabaseManager
//  EagleNetClient
//
//  Created by 王 璇 on 12-12-24.
//  Copyright (c) 2012年 wangxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@interface DatabaseManager : NSObject
{
    @public
    FMDatabase  *dbFM;
}
-(id)initWithDBname:(NSString *)dbName;

+(NSString*)getSafeValueWithDic:(NSDictionary*)rsDic withName:(NSString*)name;

-(BOOL)executeUpdate:(NSString*)sql;
-(NSMutableArray*)executeQuery:(NSString*)sql;

- (int)getDatabaseNumberBySql:(NSString*)sql;
-(void)beginTransaction;
-(void)endTransactionWithResult:(BOOL)bResult;
-(void)closeDB;

@end

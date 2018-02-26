//
//  LQDataManager.m
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/14.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#import "LQDataManager.h"
#import <FMDB.h>

@interface LQDataManager()

@property (nonatomic, strong)FMDatabaseQueue *dbQueue;

@end

@implementation LQDataManager

+ (LQDataManager *)manager{
    static LQDataManager *manager = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        
        manager = [[LQDataManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createTables];
    }
    return self;
}

- (NSString *)dbPath
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path   = [docsPath stringByAppendingPathComponent:@"LQReaderDB.sqlite"];
    
    return path;
}

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        NSString *dbPath   = [self dbPath];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return _dbQueue;
}

- (void)clearTables //清除表数据
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"drop TABLE t_reader"];//帖子实体列表
        
    }];
}
/*
 *title;
 *content;
 
  addTime;
  views;
  aID;
 rowHeight;
 */

- (void)createTables{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if (db) {
            BOOL result = [db executeUpdate:@"create table if not exists t_reader (title text ,content text ,addTime int , views int ,aID int ,rowHeight double)"];
            if (result) {
                NSLog(@"创建提醒实体表成功");
            }
        }
    }];
}

//查询
- (NSArray *)queryRemindList{
    __block  NSMutableArray *list = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *result = [db executeQuery:@"select * from t_reader"];
        while ([result next]) {
            OneModel *content = [[OneModel alloc] init];
            content.title = [result stringForColumn:@"title"];
            content.content = [result stringForColumn:@"content"];
            content.addTime = [result intForColumn:@"addTime"] ;
            content.views = [result intForColumn:@"views"];
            content.aID = [result intForColumn:@"aID'"];
            content.rowHeight = [result doubleForColumn:@"rowHeight"];
            [list addObject:content];
        }
        NSLog(@"查询  ");
    }];
    
    
    return list;
}

- (BOOL)isExistModel:(OneModel *)model{
    __block BOOL isExist = NO;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"select * from t_reader where aID = %ld",model.aID];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSLog(@"存在");
            isExist = YES;
        }
    }];
    
    return isExist;
}

- (void)updateLocalRemindData:(OneModel *)content{
    if ([self isExistModel:content]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                NSString *title = content.title ? content.title: @"";
                NSString *con = content.content ?content.content: @"";
                NSNumber *addTime = [NSNumber numberWithInt:content.addTime];
                NSNumber *views = [NSNumber numberWithInt:content.views];
                NSNumber *aID = [NSNumber numberWithInt:content.aID];
                NSNumber *rowHeight = [NSNumber numberWithDouble:content.rowHeight];
                NSString *sql = @"update t_reader set title = ? ,content = ? ,addTime = ? ,views = ? ,rowHeight = ? where aID = ?";
                BOOL updateResult = [db executeUpdate:sql,title,con,addTime,views,rowHeight,aID];
                if (updateResult) {
                    NSLog(@"更新成功");
                }
                
            }];
            
        });
    }else{
        [self insertRemindData:content];
    }
    
}

//插入数据
- (void)insertRemindData:(OneModel*)content{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"insert into t_reader (title ,content ,addTime ,views ,aID ,rowHeight) values (?,?,?,?,?,?)";
            NSString *title = content.title ? content.title: @"";
            NSString *con = content.content ?content.content: @"";
            NSNumber *addTime = [NSNumber numberWithInt:content.addTime];
            NSNumber *views = [NSNumber numberWithInt:content.views];
            NSNumber *aID = [NSNumber numberWithInt:content.aID];
            NSNumber *rowHeight = [NSNumber numberWithDouble:content.rowHeight];
            NSArray *argArray = @[title,con,addTime,views,aID,rowHeight];
            BOOL insertResult = [db executeUpdate:sql withArgumentsInArray:argArray];
            if (insertResult) {
                NSLog(@"新增成功");
            }
            
        }];
        
    });
    
}

- (void)removeRelationShipOfRemindContent:(OneModel*)content{
    
    if ([self isExistModel:content]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                
                NSString *sql = [NSString stringWithFormat:@"delete from t_reader where aID = %d",content.aID];
                BOOL result = [db executeUpdate:sql];
                if (result) {
                    NSLog(@"删除成功");
                    
                }
            }];
            
        });
    }
    
}



@end

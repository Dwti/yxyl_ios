//
//  YXRecordManager.m
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRecordManager.h"
#import "YXStatisticFileRequest.h"
#import "LogRecordEntity.h"
#import "LogRecordEntity+CoreDataProperties.h"
#import "InstantRecordEntity.h"
#import "InstantRecordEntity+CoreDataProperties.h"
#import "RegularRecordEntity.h"
#import "RegularRecordEntity+CoreDataProperties.h"
#import "YXProblemItem.h"
#import "YXStatisticRequest.h"
#import "NSString+YXRecordContent.h"

static NSString *const YXFINALKILL   = @"finalkill";

const NSTimeInterval kRetryInterval = 300; // 重试间隔时间，单位为秒
const NSUInteger     kMaxRecordCountInPack = 20; // 打包(文件)上传的最大记录数量

typedef NS_ENUM(NSUInteger, YXRecordDB) {
    YXRecordDBInstant,
    YXRecordDBRegular,
    YXRecordDBLog
};

@interface YXRecordManager()
@property (nonatomic, strong) YXStatisticFileRequest *fileRequest;
@property (nonatomic, strong) YXStatisticRequest *request;
@property (nonatomic, strong) NSMutableArray *instantRecordArray;
@property (nonatomic, assign) BOOL isInstantRecordProcessing;

@property (nonatomic, strong) NSArray *dbInstantArray;
@property (nonatomic, strong) NSArray *dbRegularArray;
@property (nonatomic, strong) NSArray *dbLogArray;
@property (nonatomic, assign) YXRecordDB currentRecordDB;
@property (nonatomic, assign) NSUInteger currentProcessIndex;
@end

@implementation YXRecordManager

+ (instancetype)sharedInstance{
    static YXRecordManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXRecordManager alloc] init];
        sharedInstance.instantRecordArray = [NSMutableArray array];
    });
    return sharedInstance;
}

// app 运行中的逻辑处理
+ (void)addRecord:(YXRecordBase *)record{
    
//    NSArray *array = @[
//                       @"1:注册成功",
//                       @"2:每次启动",
//                       @"3:提交练习/作业",
//                       @"4:收到作业(每份作业统计一次)",
//                       @"5:进入练习",
//                       @"6:进入后台",
//                       @"7:进入前台",
//                       @"8:退出app",
//                       @"9:加入班级成功",
//                       ];
//    if (record.type) {
//        NSLog(@"%@", array[record.type - 1]);
//    }
    
    YXRecordManager *manager = [YXRecordManager sharedInstance];
    
    if (record.shouldKeepLog) {
        [manager saveRecordToLog:record];
    }
    if (record.strategy == YXRecordStrategyRegular) {
        [manager saveRecordToRegular:record];
    }else if (record.strategy == YXRecordStrategyInstant) {
        [manager.instantRecordArray addObject:record];
        [manager checkInstantRecordAndStartUpload];
    }
    
    if (record.type == YXRecordQuitType) {//关闭程序，需要特殊搞一下，防杀死进程
        [self defenseKillProcess];
    }
}

+ (void)defenseKillProcess
{
    __block int countdown = 30;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXFINALKILL object:nil] subscribeNext:^(id x) {
        countdown = 0;
    }];
    while (countdown--) {//防止程序被杀
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

+ (void)addRecordWithType:(YXRecordType)type
{
    YXRecordBase *record = [[YXRecordBase alloc] init];
    record.type = type;
    [YXRecordManager addRecord:record];
}

- (void)saveRecordToLog:(YXRecordBase *)record{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        LogRecordEntity *log = [LogRecordEntity MR_createEntityInContext:localContext];
        log.content = [record toJSONString];
    }];
}

- (void)saveRecordToRegular:(YXRecordBase *)record{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        RegularRecordEntity *regular = [RegularRecordEntity MR_createEntityInContext:localContext];
        regular.content = [record toJSONString];
    }];
}

- (void)checkInstantRecordAndStartUpload{
    if (!self.isInstantRecordProcessing && self.instantRecordArray.count>0) {
        self.isInstantRecordProcessing = YES;
        YXRecordBase *record = [self.instantRecordArray firstObject];
        __weak YXRecordManager *wself = self;
        self.request = [[YXStatisticRequest alloc]init];
        self.request.content = [[record toJSONString] formatContent];

        [self.request startRequestWithRetClass:[NSDictionary class] andCompleteBlock:^(id retItem, NSError *error) {
            if (record.type == YXRecordQuitType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:YXFINALKILL object:nil];
            }
            if (error) {
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                    InstantRecordEntity *instant = [InstantRecordEntity MR_createEntityInContext:localContext];
                    instant.content = [record toJSONString];
                }];
            }
            [wself.instantRecordArray removeObjectAtIndex:0];
            wself.isInstantRecordProcessing = NO;
            [wself checkInstantRecordAndStartUpload];
        }];
    }
}

// app 每次启动后的逻辑处理
+ (void)startRegularReport{
    
    YXRecordManager *manager = [YXRecordManager sharedInstance];
    
    manager.dbInstantArray = [InstantRecordEntity MR_findAll];
    manager.dbRegularArray = [RegularRecordEntity  MR_findAll];
    manager.dbLogArray = [LogRecordEntity  MR_findAll];
    manager.currentRecordDB = YXRecordDBInstant;
    
}

- (void)setCurrentRecordDB:(YXRecordDB)currentRecordDB{
    _currentRecordDB = currentRecordDB;
    switch (currentRecordDB) {
        case YXRecordDBInstant:{
            if (self.dbInstantArray.count == 0) {
                self.currentRecordDB = YXRecordDBRegular;
            }else{
                self.currentProcessIndex = 0;
                [self uploadDBInstantRecord];
            }
        }
            break;
        case YXRecordDBRegular:{
            if (self.dbRegularArray.count == 0) {
                self.currentRecordDB = YXRecordDBLog;
            }else{
                self.currentProcessIndex = 0;
                [self uploadDBRegularRecord];
            }
        }
            break;
        case YXRecordDBLog:{
            if (self.dbLogArray.count == 0) {
                return;
            }else{
                self.currentProcessIndex = 0;
                [self uploadDBLogRecord];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)uploadDBInstantRecord{
    InstantRecordEntity *record = [self.dbInstantArray objectAtIndex:self.currentProcessIndex];
    __weak YXRecordManager *wself = self;
    YXProblemItem *item = [[YXProblemItem alloc] initWithDictionary:[record.content dictionary] error:nil];
    self.request = [[YXStatisticRequest alloc]init];
    self.request.content = [[item toJSONString] formatContent];
    
    [self.request startRequestWithRetClass:[NSDictionary class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            [wself startRetryTimer];
            return;
        }
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            [record MR_deleteEntityInContext:localContext];
        }];
        wself.currentProcessIndex++;
        if (wself.currentProcessIndex < wself.dbInstantArray.count) {
            [wself uploadDBInstantRecord];
        }else{
            wself.currentRecordDB = YXRecordDBRegular;
        }
    }];
}

- (void)uploadDBRegularRecord{
    NSInteger len = MIN(kMaxRecordCountInPack, self.dbRegularArray.count-self.currentProcessIndex);
    NSArray *recordArray = [self.dbRegularArray subarrayWithRange:NSMakeRange(self.currentProcessIndex, len)];
    __weak YXRecordManager *wself = self;
    self.request = [[YXStatisticRequest alloc]init];
    //预留的批量上传 现在没用上
//    self.regularRequest.sendType = YXSendMutltType;
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:recordArray];
//    [self.fileRequest.request addData:data forKey:@"content"];
    
    [self.fileRequest startRequestWithRetClass:[NSDictionary class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            [wself startRetryTimer];
            return;
        }
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            for (RegularRecordEntity *record in recordArray) {
                [record MR_deleteEntityInContext:localContext];
            }
        }];
        wself.currentProcessIndex += kMaxRecordCountInPack;
        if (wself.currentProcessIndex < wself.dbRegularArray.count) {
            [wself uploadDBRegularRecord];
        }else{
            wself.currentRecordDB = YXRecordDBLog;
        }
    }];
}

- (void)uploadDBLogRecord{
    NSInteger len = MIN(kMaxRecordCountInPack, self.dbLogArray.count-self.currentProcessIndex);
    NSArray *recordArray = [self.dbLogArray subarrayWithRange:NSMakeRange(self.currentProcessIndex, len)];
    __weak YXRecordManager *wself = self;
    self.fileRequest = [[YXStatisticFileRequest alloc]init];
    
    NSArray *results = [[[recordArray rac_sequence] map:^id(LogRecordEntity *value) {
        return [[[value content] formatContent] dictionary];
    }] array];
    
    NSString *name     = [NSString stringWithFormat:@"%@_0.log", [YXRecordBase timestamp]];
    NSArray *paths     = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:name];
    
    NSDictionary *dic = @{
                          @"content": results,
                          };
    
    //读取plist文件路径
    NSString *content = [dic JsonString];
    NSError *error;
    [content writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    [self.fileRequest.request addFile:filename withFileName:name andContentType:@"application/octet-stream" forKey:@"file"];
    
    [self.fileRequest startRequestWithRetClass:[NSDictionary class] andCompleteBlock:^(id retItem, NSError *error) {
        if (error) {
            [wself startRetryTimer];
            return;
        }
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            for (LogRecordEntity *record in recordArray) {
                [record MR_deleteEntityInContext:localContext];
            }
        }];
        wself.currentProcessIndex += kMaxRecordCountInPack;
        if (wself.currentProcessIndex < wself.dbLogArray.count) {
            [wself uploadDBLogRecord];
        }else{
            // all DB record upload complete!
        }
    }];
    
}

- (void)startRetryTimer{
    [NSTimer scheduledTimerWithTimeInterval:kRetryInterval target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}

- (void)timerAction{
    if (self.currentRecordDB == YXRecordDBInstant) {
        [self uploadDBInstantRecord];
    }else if (self.currentRecordDB == YXRecordDBRegular){
        [self uploadDBRegularRecord];
    }else if (self.currentRecordDB == YXRecordDBLog){
        [self uploadDBLogRecord];
    }
}

@end

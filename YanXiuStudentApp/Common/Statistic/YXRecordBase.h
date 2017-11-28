//
//  YXRecordBase.h
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 *  上报类型
 */
typedef NS_ENUM(NSInteger, YXRecordType) {
    /**
     *  注册成功
     */
    YXRecordResigerType    = 1,
    /**
     *  每次启动
     */
    YXRecordStartType      = 2,
    /**
     *  提交练习/作业
     */
    YXRecordSubmitWorkType = 3,
    /**
     *  收到作业(每份作业统计一次)
     */
    YXRecordReciveWorkType = 4,
    /**
     *  进入练习
     */
    YXRecordPractiseType   = 5,
    /**
     *  进入后台
     */
    YXRecordBackgroundType = 6,
    /**
     *  进入前台
     */
    YXRecordActiveType     = 7,
    /**
     *  退出app
     */
    YXRecordQuitType       = 8,
    /**
     *  加入班级成功
     */
    YXRecordClassType      = 9,
    /**
     *  首次启动
     */
    YXRecordLaunchType     = 10,
    /**
     *  跳出BC资源
     */
    YXRecordQuitBCType      = 11,
    /**
     *  完成BC资源
     */
    YXRecordFinishBCType     = 12,
    
};

// record strategy enumeration
typedef NS_ENUM(NSUInteger, YXRecordStrategy) {
    YXRecordStrategyInstant,
    YXRecordStrategyRegular
};

@interface YXRecordBase : JSONModel

@property (nonatomic, assign) YXRecordStrategy strategy; // default is YXRecordStrategyInstant
@property (nonatomic, assign) BOOL shouldKeepLog;  // default is YES
@property (nonatomic, assign) YXRecordType type;

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *resID;

+ (NSString *)timestamp;

@end

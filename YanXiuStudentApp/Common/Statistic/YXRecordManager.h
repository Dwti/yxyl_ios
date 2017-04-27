//
//  YXRecordManager.h
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRecordBase.h"

@interface YXRecordManager : NSObject

+ (void)addRecord:(YXRecordBase *)record;

+ (void)addRecordWithType:(YXRecordType)type;

+ (void)startRegularReport;

@end

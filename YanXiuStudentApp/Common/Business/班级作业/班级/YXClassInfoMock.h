//
//  YXClassInfoMock.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXSearchClassRequest.h"

typedef NS_ENUM(NSInteger, YXClassActionType) {
    YXClassActionTypeJoin,          //申请加入
    YXClassActionTypeCancelJoining, //取消申请
    YXClassActionTypeExit           //退出班级
};

@interface YXClassInfoMock : NSObject
@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gid;

@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *headcount;

@property (nonatomic, strong) YXSearchClassItem_Data *rawData;

+ (YXClassInfoMock *)mockItemFromRealData:(YXSearchClassItem_Data *)data;

@end

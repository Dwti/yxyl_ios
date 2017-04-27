//
//  YXRedManager.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXRedManager.h"
#import "YXRedNumberRequest.h"

@interface YXRedManager()

@property (nonatomic, strong) YXRedNumberRequest *request;

@end

@implementation YXRedManager

+ (void)requestPendingHomeWorkNumber{
    YXRedManager *manager = [YXRedManager defaultManager];
    manager.request = [[YXRedNumberRequest alloc] init];
    [manager.request startRequestWithRetClass:[YXRedNumberItem class] andCompleteBlock:^(YXRedNumberItem *retItem, NSError *error) {
        manager.paperNum = retItem.property.paperNum;
        [[NSNotificationCenter defaultCenter] postNotificationName:YXRedNotification object:retItem.property.paperNum];
    }];
}

+ (YXRedManager *)defaultManager
{
    static YXRedManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YXRedManager new];
    });
    return manager;
}

@end

//
//  YXUserInfoRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/5.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXUserModel.h"

extern NSString *const YXUserInfoGetSuccessNotification;

@interface YXUserInfoItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end

// 用户基本信息
@interface YXUserInfoRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId;   //学段Id
@property (nonatomic, strong) NSString *stageName; //学段名

@end

@interface YXUserInfoHelper : NSObject

+ (instancetype)sharedHelper;

- (void)requestCompeletion:(void(^)())completion;

@end

//
//  YXUpdateUserInfoHelper.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/23.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXUploadHeadImgRequest.h"

typedef NS_ENUM(NSInteger, YXUpdateUserInfoType) {
    YXUpdateUserInfoTypeRealname, //姓名
    YXUpdateUserInfoTypeNickname, //昵称
    YXUpdateUserInfoTypeSex,      //性别
    YXUpdateUserInfoTypeArea,     //地区（省市区县）
    YXUpdateUserInfoTypeSchool,   //学校（Id或名称）
    YXUpdateUserInfoTypeStage     //学段
};

extern NSString *const YXUpdateUserInfoSuccessNotification;
extern NSString *const YXUpdateUserInfoTypeKey; // 值为NSNumber对象
extern NSString *const YXUpdateHeadImgSuccessNotification;

@interface YXUpdateUserInfoHelper : NSObject

+ (instancetype)instance;

- (void)requestWithType:(YXUpdateUserInfoType)type
                  param:(NSDictionary *)param
             completion:(void(^)(NSError *error))completion;

- (void)updateHeadImageWithImage:(UIImage *)image completeBlock:(void(^)(YXUploadHeadImgItem *item, NSError *error))completeBlock;

@end

//
//  ClassHomeworkDataManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXSearchClassRequest.h"
#import "YXJoinClassRequest.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXCancelReplyClassRequest.h"
#import "YXExitClassRequest.h"
#import "YXGetQuestionListRequest.h"
#import "YXHomework.h"
#import "YXGetQuestionReportRequest.h"
@interface ClassHomeworkDataManager : NSObject
// 请求班级详情
+ (void)requestClassDetailWithClassID:(NSString *)classID completeBlock:(void(^)(YXSearchClassItem *item, NSError *error))completeBlock;
// 搜索班级信息
+ (void)searchClassWithClassID:(NSString *)classID completeBlock:(void(^)(YXSearchClassItem *item, NSError *error))completeBlock;
// 请求加入班级
+ (void)joinClassWithClassID:(NSString *)classID
                      verifyStatus:(NSString *)verifyStatus
                        verifyMessage:(NSString *)verifyMessage
                        completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
// 取消加入班级的申请
+ (void)cancelJoiningClassWithClassID:(NSString *)classID completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock;
// 退出班级
+ (void)exitClassWithClassID:(NSString *)classID completeBlock:(void(^)(HttpBaseRequestItem * item, NSError *error))completeBlock;
// 请求作业列表
+ (void)getQuestionListWithPaperID:(NSString *)paperID completeBlock:(void(^)(YXIntelligenceQuestionListItem * item, NSError *error))completeBlock;
// 请求报告
+ (void)getQuestionReportWithPaperID:(NSString *)paperID completeBlock:(void(^)(YXIntelligenceQuestionListItem * item, NSError *error))completeBlock;
@end

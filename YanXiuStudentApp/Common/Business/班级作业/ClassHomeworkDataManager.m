//
//  ClassHomeworkDataManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ClassHomeworkDataManager.h"
@interface ClassHomeworkDataManager ()
@property (nonatomic, strong) YXSearchClassRequest *searchClassRequest;
@property (nonatomic, strong) YXJoinClassRequest *joinClassRequest;
@property (nonatomic, strong) YXUpdateUserInfoRequest *updateUserInfoRequest;
@property (nonatomic, strong) YXCancelReplyClassRequest *cancelReplyClassRequest;
@property (nonatomic, strong) YXExitClassRequest *exitClassRequest;
@property (nonatomic, strong) YXGetQuestionListRequest *getQuestionListRequest;
@property (nonatomic, strong) YXGetQuestionReportRequest *getQuestionReportRequest;
@end

@implementation ClassHomeworkDataManager
+ (instancetype)sharedInstance {
    static ClassHomeworkDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ClassHomeworkDataManager alloc] init];
    });
    return sharedInstance;
}

+ (void)requestClassDetailWithClassID:(NSString *)classID completeBlock:(void(^)(YXSearchClassItem *item, NSError *error))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.searchClassRequest stopRequest];
    manager.searchClassRequest = [[YXSearchClassRequest alloc]init];
    manager.searchClassRequest.classId = classID;
    WEAK_SELF
    [manager.searchClassRequest startRequestWithRetClass:[YXSearchClassItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        NSError *notExistError = [NSError errorWithDomain:@"not exist" code:2 userInfo:@{NSLocalizedDescriptionKey:@"不存在的班级号码"}];
        if (error) {
            if (error.code == 2) {
                BLOCK_EXEC(completeBlock,retItem,notExistError);
            }else{
                BLOCK_EXEC(completeBlock,retItem,error);
            }
            return;
        }
        YXSearchClassItem *ret = retItem;
        if (![ret.data count]) {
            BLOCK_EXEC(completeBlock,retItem,notExistError);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)searchClassWithClassID:(NSString *)classID completeBlock:(void(^)(YXSearchClassItem *item, NSError *error))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.searchClassRequest stopRequest];
    manager.searchClassRequest = [[YXSearchClassRequest alloc]init];
    manager.searchClassRequest.classId = classID;
    WEAK_SELF
    [manager.searchClassRequest startRequestWithRetClass:[YXSearchClassItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        NSError *notExistError = [NSError errorWithDomain:@"not exist" code:2 userInfo:@{NSLocalizedDescriptionKey:@"班级不存在"}];
        if (error) {
            if (error.code == 2) {
                BLOCK_EXEC(completeBlock,retItem,notExistError);
            }else{
                BLOCK_EXEC(completeBlock,retItem,error);
            }
            return;
        }
        YXSearchClassItem *ret = retItem;
        if (![ret.data count]) {
            BLOCK_EXEC(completeBlock,retItem,notExistError);
            return;
        }
        YXSearchClassItem_Data *data = ret.data[0];
        if (data.status.integerValue == 2) {
            NSError *cannotJoinError = [NSError errorWithDomain:@"cannot join" code:2 userInfo:@{NSLocalizedDescriptionKey:@"此班级不允许学生加入"}];
            BLOCK_EXEC(completeBlock,retItem,cannotJoinError);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)joinClassWithClassID:(NSString *)classID verifyStatus:(NSString *)verifyStatus verifyMessage:(NSString *)verifyMessage completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.joinClassRequest stopRequest];
    manager.joinClassRequest = [[YXJoinClassRequest alloc] init];
    manager.joinClassRequest.classId = classID;
    manager.joinClassRequest.needCheck = verifyStatus;
    manager.joinClassRequest.validMsg = verifyMessage;
    WEAK_SELF
    [manager.joinClassRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        [manager updateUserInfoWithName:verifyMessage updatedBlock:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:YXJoinClassSuccessNotification object:nil];
        BLOCK_EXEC(completeBlock,retItem,nil)
    }];
}
- (void)updateUserInfoWithName:(NSString *)name updatedBlock:(void (^)(NSError *))updatedBlock {
    self.updateUserInfoRequest = [[YXUpdateUserInfoRequest alloc]init];
    self.updateUserInfoRequest.realname = name;
    WEAK_SELF
    [self.updateUserInfoRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(updatedBlock,error);
        }else{
            [YXUserManager sharedManager].userModel.realname = name;
            [[YXUserManager sharedManager] saveUserData];
            BLOCK_EXEC(updatedBlock,nil);
        }
    }];
}

+ (void)cancelJoiningClassWithClassID:(NSString *)classID completeBlock:(void(^)(HttpBaseRequestItem *item, NSError *error))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.cancelReplyClassRequest stopRequest];
    manager.cancelReplyClassRequest = [[YXCancelReplyClassRequest alloc] init];
    manager.cancelReplyClassRequest.classId = classID;
    WEAK_SELF
    [manager.cancelReplyClassRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:YXCancelReplyClassSuccessNotification object:nil];
    }];
}

+ (void)exitClassWithClassID:(NSString *)classID completeBlock:(void (^)(HttpBaseRequestItem *, NSError *))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.exitClassRequest stopRequest];
    manager.exitClassRequest = [[YXExitClassRequest alloc] init];
    manager.exitClassRequest.classId = classID;
    WEAK_SELF
    [manager.exitClassRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:YXExitClassSuccessNotification object:nil];
    }];
}

+ (void)getQuestionListWithPaperID:(NSString *)paperID completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.getQuestionListRequest stopRequest];
    manager.getQuestionListRequest = [[YXGetQuestionListRequest alloc] init];
    manager.getQuestionListRequest.paperId = paperID;
    WEAK_SELF
    [manager.getQuestionListRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}

+ (void)getQuestionReportWithPaperID:(NSString *)paperID completeBlock:(void (^)(YXIntelligenceQuestionListItem *, NSError *))completeBlock {
    ClassHomeworkDataManager *manager = [ClassHomeworkDataManager sharedInstance];
    [manager.getQuestionReportRequest stopRequest];
    manager.getQuestionReportRequest = [[YXGetQuestionReportRequest alloc] init];
    manager.getQuestionReportRequest.ppid = paperID;
    manager.getQuestionReportRequest.flag = @"1";
    WEAK_SELF
    [manager.getQuestionReportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,retItem,error);
            return;
        }
        BLOCK_EXEC(completeBlock,retItem,nil);
    }];
}
@end

//
//  YXUpdateUserInfoHelper.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/23.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXUpdateUserInfoHelper.h"
#import "YXUpdateUserInfoRequest.h"

NSString *const YXUpdateUserInfoSuccessNotification = @"kYXUpdateUserInfoSuccessNotification";
NSString *const YXUpdateUserInfoTypeKey = @"kYXUpdateUserInfoTypeKey";
NSString *const YXUpdateHeadImgSuccessNotification = @"kYXUpdateHeadImgSuccessNotification";

@interface YXUpdateUserInfoHelper ()
@property (nonatomic, strong) YXUpdateUserInfoRequest *request;
@property (nonatomic, strong) YXUploadHeadImgRequest *uploadHeadImgRequest;
@end

@implementation YXUpdateUserInfoHelper
+ (instancetype)instance
{
    static YXUpdateUserInfoHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YXUpdateUserInfoHelper alloc] init];
    });
    return instance;
}

- (void)requestWithType:(YXUpdateUserInfoType)type
                  param:(NSDictionary *)param
             completion:(void (^)(NSError *))completion
{
    if (type == YXUpdateUserInfoTypeSoundSwitch) {
        [self saveDataWithParam:param type:type];
        BLOCK_EXEC(completion,nil);
        return;
    }
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXUpdateUserInfoRequest alloc] init];
    [self setRequestWithParam:param type:type];
    @weakify(self);
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (completion) {
            completion(error);
        }
        if (retItem && !error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveDataWithParam:param type:type];
                [[NSNotificationCenter defaultCenter] postNotificationName:YXUpdateUserInfoSuccessNotification object:nil userInfo:@{YXUpdateUserInfoTypeKey:@(type)}];
            });
        }
    }];
}

- (void)setRequestWithParam:(NSDictionary *)param type:(YXUpdateUserInfoType)type
{
    switch (type) {
        case YXUpdateUserInfoTypeRealname:
            self.request.realname = [param objectForKey:@"realname"];
            break;
        case YXUpdateUserInfoTypeNickname:
            self.request.nickname = [param objectForKey:@"nickname"];
            break;
        case YXUpdateUserInfoTypeSex:
            self.request.sex = [param objectForKey:@"sex"];
            break;
        case YXUpdateUserInfoTypeArea:
            self.request.provinceid = [param objectForKey:@"provinceid"];
            self.request.cityid = [param objectForKey:@"cityid"];
            self.request.areaid = [param objectForKey:@"areaid"];
            break;
        case YXUpdateUserInfoTypeSchool:
            self.request.schoolid = [param objectForKey:@"schoolid"];
            self.request.schoolName = [param objectForKey:@"schoolName"];
            break;
        case YXUpdateUserInfoTypeStage:
            self.request.stageid = [param objectForKey:@"stageid"];
            break;
        case YXUpdateUserInfoTypeSoundSwitch:
            self.request.stageid = [param objectForKey:@"soundSwitchState"];
            break;
        default:
            break;
    }
}

- (void)saveDataWithParam:(NSDictionary *)param type:(YXUpdateUserInfoType)type
{
    switch (type) {
        case YXUpdateUserInfoTypeRealname:
            [YXUserManager sharedManager].userModel.realname = [param objectForKey:@"realname"];
            break;
        case YXUpdateUserInfoTypeNickname:
            [YXUserManager sharedManager].userModel.nickname = [param objectForKey:@"nickname"];
            break;
        case YXUpdateUserInfoTypeSex:
            [YXUserManager sharedManager].userModel.sex = [param objectForKey:@"sex"];
            break;
        case YXUpdateUserInfoTypeArea:
            [YXUserManager sharedManager].userModel.provinceid = [param objectForKey:@"provinceid"];
            [YXUserManager sharedManager].userModel.provinceName = [param objectForKey:@"provinceName"];
            [YXUserManager sharedManager].userModel.cityid = [param objectForKey:@"cityid"];
            [YXUserManager sharedManager].userModel.cityName = [param objectForKey:@"cityName"];
            [YXUserManager sharedManager].userModel.areaid = [param objectForKey:@"areaid"];
            [YXUserManager sharedManager].userModel.areaName = [param objectForKey:@"areaName"];
            break;
        case YXUpdateUserInfoTypeSchool:
            [YXUserManager sharedManager].userModel.schoolid = [param objectForKey:@"schoolid"];
            [YXUserManager sharedManager].userModel.schoolName = [param objectForKey:@"schoolName"];
            break;
        case YXUpdateUserInfoTypeStage:
            [YXUserManager sharedManager].userModel.stageid = [param objectForKey:@"stageid"];
            [YXUserManager sharedManager].userModel.stageName = [param objectForKey:@"stageName"];
            break;
        case YXUpdateUserInfoTypeSoundSwitch:
            [YXUserManager sharedManager].userModel.soundSwitchState = [param objectForKey:@"soundSwitchState"];
        default:
            break;
    }
    [[YXUserManager sharedManager] saveUserData];
}

- (void)updateHeadImageWithImage:(UIImage *)image completeBlock:(void(^)(YXUploadHeadImgItem *item, NSError *error))completeBlock {
    NSData *data = [UIImage compressionImage:image limitSize:2*1024*1024];
    [self.uploadHeadImgRequest stopRequest];
    self.uploadHeadImgRequest = [[YXUploadHeadImgRequest alloc] init];
    [self.uploadHeadImgRequest.request setData:data
                                  withFileName:@"head.jpg"
                                andContentType:nil
                                        forKey:@"file"];
    WEAK_SELF
    [self.uploadHeadImgRequest startRequestWithRetClass:[YXUploadHeadImgItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        YXUploadHeadImgItem *item = retItem;
        YXUploadHeadImgItem_Data *data = item.data[0];
        [YXUserManager sharedManager].userModel.head = data.head;
        [[YXUserManager sharedManager] saveUserData];
        [[NSNotificationCenter defaultCenter] postNotificationName:YXUpdateHeadImgSuccessNotification object:nil];
        BLOCK_EXEC(completeBlock,item,nil);
    }];
}

@end

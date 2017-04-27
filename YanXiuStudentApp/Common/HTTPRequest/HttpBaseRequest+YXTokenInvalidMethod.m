//
//  HttpBaseRequest+YXTokenInvalidMethod.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/24.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "HttpBaseRequest+YXTokenInvalidMethod.h"

@implementation HttpBaseRequest (YXTokenInvalidMethod)

- (void)operationWithInvalidToken:(NSString *)token
                          retItem:(id)retItem
                            error:(NSError *)error
                    completeBlock:(HttpRequestCompleteBlock)completeBlock
{
    if (error
        && error.code == 99
        && [token yx_isValidString]) { // token存在且失效
        NSString *errorString = error.localizedDescription ?:@"帐号授权已失效，请重新登录";
        [[YXUserManager sharedManager] logout];
        [[UIApplication sharedApplication].keyWindow.rootViewController yx_showToast:errorString];
    } else {
        if (completeBlock) {
            completeBlock(retItem, error);
        }
    }
}

@end

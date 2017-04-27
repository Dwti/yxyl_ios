//
//  YXOauthLoginRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/24.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXOauthLoginRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end

@interface YXOauthLoginRequest : YXPostRequest

@property (nonatomic, strong) NSString *openid;   //用户第三方平台唯一标示
@property (nonatomic, strong) NSString *platform; //平台id(qq标示qq平台， weixin标示微信平台)
@property (nonatomic, strong) NSString *deviceId; //设备id
@property (nonatomic, strong) NSString *unionId;

@end

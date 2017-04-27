//
//  YXEditProfileViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController_Pad.h"

@interface YXEditProfileViewController_Pad : YXLoginBaseViewController_Pad

@property (nonatomic, strong) NSDictionary *thirdLoginParams; //第三方登录时传参

- (void)setMobile:(NSString *)mobile password:(NSString *)password;

@end

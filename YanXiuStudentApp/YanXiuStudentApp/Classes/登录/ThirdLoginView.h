//
//  ThirdLoginView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ThirdLoginType) {
    ThirdLogin_QQ,
    ThirdLogin_Weixin
};

@interface ThirdLoginView : UIView
@property (nonatomic, strong) void(^loginAction) (ThirdLoginType type);
@end

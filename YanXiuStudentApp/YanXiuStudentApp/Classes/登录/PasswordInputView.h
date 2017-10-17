//
//  PasswordInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInputView.h"

@interface PasswordInputView : UIView
@property (nonatomic, strong) LoginInputView *inputView;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong) void(^textChangeBlock) (void);
@end

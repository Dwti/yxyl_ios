//
//  VerifyCodeInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyCodeInputView : UIView
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) void(^timerPauseBlock) ();
@property (nonatomic, strong) void(^textChangeBlock) ();
@end

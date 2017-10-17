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
@property (nonatomic, strong) void(^textChangeBlock) (void);
@property (nonatomic, strong) void(^sendAction) (void);
@property (nonatomic, strong, readonly) NSString *text;
- (void)startTimer;
- (void)stopTimer;
@end

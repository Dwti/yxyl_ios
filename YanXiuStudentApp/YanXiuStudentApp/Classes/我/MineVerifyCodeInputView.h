//
//  MineVerifyCodeInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineVerifyCodeInputView : UIView
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) void(^textChangeBlock) ();
@property (nonatomic, strong) void(^sendAction) ();
@property (nonatomic, strong, readonly) NSString *text;
- (void)startTimer;
- (void)stopTimer;
@end

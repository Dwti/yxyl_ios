//
//  MinePhoneInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineInputView.h"

@interface MinePhoneInputView : UIView
@property (nonatomic, strong) MineInputView *inputView;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong) void(^textChangeBlock) ();
@end

//
//  QAInputAccessoryView.h
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAInputAccessoryView : UIView

@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, copy) void (^confirmBlock)(void);

@end

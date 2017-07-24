//
//  MineInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendTextField.h"

@interface MineInputView : UIView
@property (nonatomic, strong) ExtendTextField *textField;
@property (nonatomic, strong) NSString *placeHolder;
@end

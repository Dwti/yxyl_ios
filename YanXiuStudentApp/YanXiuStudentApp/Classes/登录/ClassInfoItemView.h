//
//  ClassInfoItemView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInputView.h"

@interface ClassInfoItemView : UIView
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) LoginInputView *inputView;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong) void(^textChangeBlock) ();
@end

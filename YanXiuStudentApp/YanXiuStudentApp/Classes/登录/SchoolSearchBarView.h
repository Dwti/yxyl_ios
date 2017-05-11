//
//  SchoolSearchBarView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolSearchBarView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) void(^searchBlock)(NSString *text);
@end

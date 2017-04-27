//
//  YXComplexQuestionDetailViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQuestionFactory.h"

@interface YXComplexQuestionDetailViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) YXQuestion *question;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *typeButton;
@property (nonatomic, strong) UILabel *identifierLabel;
@property (nonatomic, strong) UITextField *identifierField;
@end

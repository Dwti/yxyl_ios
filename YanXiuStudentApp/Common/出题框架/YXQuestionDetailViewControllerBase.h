//
//  YXQuestionDetailViewControllerBase.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXIntelligenceQuestion.h"

@interface YXQuestionDetailViewControllerBase : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) YXQuestion *question;

@property (nonatomic, strong) UIView *containerView; // 子类添加的所有subview都要放在containerView上面

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *typeButton;
@property (nonatomic, strong) UILabel *identifierLabel;
@property (nonatomic, strong) UITextField *identifierField;

- (void)setupUI;
- (void)saveData;
@end

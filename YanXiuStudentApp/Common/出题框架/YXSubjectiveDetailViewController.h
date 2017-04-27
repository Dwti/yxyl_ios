//
//  YXSubjectiveDetailViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionDetailViewControllerBase.h"

@interface YXSubjectiveDetailViewController : YXQuestionDetailViewControllerBase
//设置照片个数
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UITextField *answerField;
//设置是否批改
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UIButton *checkButton;
//设置得分
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UITextField *scoreField;
//设置评语
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UITextView *commentView;
@end

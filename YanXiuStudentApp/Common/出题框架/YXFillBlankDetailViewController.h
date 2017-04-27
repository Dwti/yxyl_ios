//
//  YXFillBlankDetailViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionDetailViewControllerBase.h"

@interface YXFillBlankDetailViewController : YXQuestionDetailViewControllerBase
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) NSMutableArray *answerFields;
@end

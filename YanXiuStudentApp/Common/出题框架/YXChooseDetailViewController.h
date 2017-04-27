//
//  YXChooseDetailViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionDetailViewControllerBase.h"

@interface YXChooseDetailViewController : YXQuestionDetailViewControllerBase
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) NSMutableArray *answerButtons;
@end

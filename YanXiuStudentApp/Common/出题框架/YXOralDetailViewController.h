//
//  YXOralDetailViewController.h
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXQuestionDetailViewControllerBase.h"

@interface YXOralDetailViewController : YXQuestionDetailViewControllerBase
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) NSMutableArray *answerButtons;
@end

//
//  QAComplexHeaderFactory.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAComplexHeaderFactory.h"
#import "QAReadStemCell.h"
#import "QAComplexHeaderEmptyCell.h"
#import "QAListenStemCell.h"

NSString * const kHeaderCellReuseID = @"kHeaderCellReuseID";

@implementation QAComplexHeaderFactory
+ (UITableViewCell<QAComplexHeaderCellDelegate> *)headerCellClassForQuestion:(QAQuestion *)question {
    if (question.templateType == YXQATemplateReadComplex) {
        QAReadStemCell *cell = [[QAReadStemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCellReuseID];
        [cell updateWithString:question.stem isSubQuestion:NO];
        [cell.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
        return cell;
    }
    if (question.templateType == YXQATemplateListenComplex) {
        QAListenStemCell *cell = [[QAListenStemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCellReuseID];
        [cell updateWithString:question.stem isSubQuestion:NO];
        [cell.playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(cell.htmlView.mas_bottom).offset(12.0f);
            make.bottom.mas_equalTo(10.0f);
        }];
        return cell;
    }
    
    return [[QAComplexHeaderEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCellReuseID];;
}
@end

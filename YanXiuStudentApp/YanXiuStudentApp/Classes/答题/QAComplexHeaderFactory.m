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
        return cell;
    }
    if (question.templateType == YXQATemplateListenComplex) {
        QAListenStemCell *cell = [[QAListenStemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCellReuseID];
        cell.item = question;
        [cell updateWithString:question.stem isSubQuestion:NO];
        return cell;
    }
    
    return [[QAComplexHeaderEmptyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHeaderCellReuseID];;
}
@end

//
//  QAComplexHeaderFactory.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAComplexHeaderCellDelegate.h"

extern NSString * const kHeaderCellReuseID;

@interface QAComplexHeaderFactory : NSObject
+ (UITableViewCell<QAComplexHeaderCellDelegate> *)headerCellClassForQuestion:(QAQuestion *)question;
@end

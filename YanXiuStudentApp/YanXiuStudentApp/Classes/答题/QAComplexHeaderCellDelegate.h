//
//  QAComplexHeaderCellDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QAComplexHeaderCellDelegate <NSObject>
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> cellHeightDelegate;

- (CGFloat)heightForQuestion:(QAQuestion *)question;
@end

//
//  QAClassifyOptionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/5.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyOptionCell.h"
#import "QAClassifyTextOptionCell.h"
#import "QAClassifyImageOptionCell.h"

@implementation QAClassifyOptionCell

+ (QAClassifyOptionCell *)cellWithOption:(NSString *)option {
    NSRange range = [option rangeOfString:@"src=\".+?\"" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        QAClassifyTextOptionCell *cell = [[QAClassifyTextOptionCell alloc]init];
        cell.optionString = option;
        return cell;
    }else {
        QAClassifyImageOptionCell *cell = [[QAClassifyImageOptionCell alloc]init];
        cell.optionString = option;
        return cell;
    }
}

- (CGSize)defaultSize {
    return CGSizeZero;
}

@end

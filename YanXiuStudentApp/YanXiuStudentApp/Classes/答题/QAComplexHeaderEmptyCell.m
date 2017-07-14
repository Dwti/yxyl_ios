//
//  QAComplexHeaderEmptyCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAComplexHeaderEmptyCell.h"

@implementation QAComplexHeaderEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - QAComplexHeaderCellDelegate
- (CGFloat)heightForQuestion:(QAQuestion *)question {
    return 0.f;
}

- (void)setCellHeightDelegate:(id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    
}

- (id<YXHtmlCellHeightDelegate>)cellHeightDelegate {
    return nil;
}

- (void)leaveForeground {
    
}

@end

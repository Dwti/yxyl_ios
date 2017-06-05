//
//  QAFillBlankCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAFillBlankCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) id<QAAnswerStateChangeDelegate> answerStateChangeDelegate;

+ (CGFloat)heightForString:(NSString *)string;

@end

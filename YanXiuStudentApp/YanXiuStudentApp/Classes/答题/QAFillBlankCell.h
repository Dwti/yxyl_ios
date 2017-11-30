//
//  QAFillBlankCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MistakeFillBlankQuestionAnswerStateChangeBlock) (NSUInteger answerState);

@interface QAFillBlankCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) id<QAAnswerStateChangeDelegate> answerStateChangeDelegate;

+ (CGFloat)heightForString:(NSString *)string;

- (UIView *)currentBlankView;
- (void)resetCurrentBlank;
- (void)setMistakeFillBlankQuestionAnswerStateChangeBlock:(MistakeFillBlankQuestionAnswerStateChangeBlock)block;
@end

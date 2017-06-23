//
//  QAAnalysisResultCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

typedef NS_ENUM(NSUInteger, QAAnswerResultType) {
    QAAnswerResultType_Objective, // 客观题的作答结果
    QAAnswerResultType_Subjective, // 主观题的作答结果
};


@interface QAAnalysisResultCell : QAAnalysisBaseCell
@property (nonatomic, assign) QAAnswerResultType type;
@property (nonatomic, assign) BOOL isMarked;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateUI;
+ (CGFloat)heightForString:(NSString *)string;

@end

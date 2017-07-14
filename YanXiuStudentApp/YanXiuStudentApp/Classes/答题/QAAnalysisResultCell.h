//
//  QAAnalysisResultCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisResultCell : QAAnalysisBaseCell
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateUI;
+ (CGFloat)heightForString:(NSString *)string;

@end

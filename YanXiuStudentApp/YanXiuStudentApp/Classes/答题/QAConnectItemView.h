//
//  QAConnectItemView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAConnectItemView : UIView
@property (nonatomic, assign) CGFloat maxContentWidth;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) YXQAAnswerState answerState;

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width;
@end

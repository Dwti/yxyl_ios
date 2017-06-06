//
//  QAClozeQuestionCell.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAClozeQuestionCellDelegate.h"

@interface QAClozeQuestionCell : UITableViewCell
@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) QAQuestion *qaData;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) id<QAClozeQuestionCellDelegate> selectItemDelegate;

+ (CGFloat)heightForString:(NSString *)string;
- (void)selectAnswerWithQuestion:(NSInteger)question;

@end

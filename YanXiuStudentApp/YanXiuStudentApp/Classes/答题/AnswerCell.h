//
//  AnswerCell.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/10/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"
#import "YXHtmlCellHeightDelegate.h"


@interface AnswerCell : UITableViewCell

@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, assign) BOOL isClassifyQuestionAnalysis;

+ (CGFloat)heightForString:(NSString *)string;

@end

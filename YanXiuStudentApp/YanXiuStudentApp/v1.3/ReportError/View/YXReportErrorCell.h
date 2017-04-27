//
//  YXReportErrorCell.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXTopBottomLineCell.h"
#import "YXQAAnalysisReportErrorViewDelegate.h"

@interface YXReportErrorCell : UITableViewCell

@property (nonatomic, weak) id<YXQAAnalysisReportErrorViewDelegate>delegate;

+ (CGFloat)height;

@end

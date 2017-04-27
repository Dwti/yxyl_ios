//
//  YXQAAnalysisReportErrorCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisReportErrorViewDelegate.h"

@interface YXQAAnalysisReportErrorCell_Pad : UITableViewCell
@property (nonatomic, assign)id<YXQAAnalysisReportErrorViewDelegate> delegate;
+ (CGFloat)height;
@end

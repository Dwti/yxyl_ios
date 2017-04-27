//
//  YXQAAnalysisUnfoldView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisUnfoldDelegate.h"

@interface YXQAAnalysisUnfoldView_Pad : UITableViewHeaderFooterView
@property (nonatomic, assign)id<YXQAAnalysisUnfoldDelegate> delegate;
+ (CGFloat)height;
@end

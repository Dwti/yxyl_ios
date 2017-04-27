//
//  YXJieXiShowView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisUnfoldDelegate.h"

@interface YXJieXiShowView : UIView

@property (nonatomic, assign)id<YXQAAnalysisUnfoldDelegate> delegate;

+ (CGFloat)height;

@end

//
//  YXAnalysisDataDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXQADefinitions.h"

@protocol YXQAAnalysisDataDelegate <NSObject>

- (BOOL)shouldShowAnalysisDataWithQAItemType:(YXQATemplateType)qaType analysisType:(YXQAAnalysisType)analysisType;

@end

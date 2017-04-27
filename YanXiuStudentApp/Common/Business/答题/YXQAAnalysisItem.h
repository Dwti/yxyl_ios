//
//  YXQAAnalysisItem.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXQADefinitions.h"

@interface YXQAAnalysisItem : NSObject

@property (nonatomic, assign) YXQAAnalysisType type;

/**
 *  获取解析类型对应的文字名称
 *
 *  @return 返回类型的文字名称，如个人统计，当前状态等
 */
- (NSString *)typeString;

@end

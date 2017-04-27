//
//  YXPaperManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXIntelligenceQuestion.h"

@interface YXPaperManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray *questions;

- (QAPaperModel *)modelFromPaper;
- (NSString *)paperJsonString;

@end

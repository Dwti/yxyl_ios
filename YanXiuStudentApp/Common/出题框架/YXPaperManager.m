//
//  YXPaperManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPaperManager.h"

@implementation YXPaperManager

+ (instancetype)sharedInstance{
    static YXPaperManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YXPaperManager alloc] init];
        sharedInstance.questions = [NSMutableArray array];
    });
    return sharedInstance;
}

- (QAPaperModel *)modelFromPaper{
    YXIntelligenceQuestion *intelQuestion = [[YXIntelligenceQuestion alloc]init];
    intelQuestion.name = @"自己生成的试卷";
    
    YXIntelligenceQuestion_PaperStatus *paperStatus = [[YXIntelligenceQuestion_PaperStatus alloc]init];
    paperStatus.status = @"2";
    intelQuestion.paperStatus = paperStatus;
    
    intelQuestion.paperTest = (NSArray<YXIntelligenceQuestion_PaperTest, Optional> *)self.questions;
    
    NSLog(@"Paper: %@",[intelQuestion toJSONString]);
    
    QAPaperModel *model = [QAPaperModel modelFromRawData:intelQuestion];
    return model;
}

- (NSString *)paperJsonString{
    YXIntelligenceQuestion *intelQuestion = [[YXIntelligenceQuestion alloc]init];
    intelQuestion.name = @"自己生成的试卷";
    
    intelQuestion.paperTest = (NSArray<YXIntelligenceQuestion_PaperTest, Optional> *)self.questions;
    return[intelQuestion toJSONString];
}

@end

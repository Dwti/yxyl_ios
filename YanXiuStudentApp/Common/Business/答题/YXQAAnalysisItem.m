//
//  YXQAAnalysisItem.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisItem.h"

@implementation YXQAAnalysisItem

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXAnalysisUnknown;
    }
    return self;
}

- (NSString *)typeString{
    if (self.type == YXAnalysisCurrentStatus) {
        return @"作答结果";
    }else if (self.type == YXAnalysisDifficulty){
        return @"难度";
    }else if (self.type == YXAnalysisAnswer){
        return @"答案";
    }else if (self.type == YXAnalysisAnalysis){
        return @"题目解析";
    }else if (self.type == YXAnalysisKnowledgePoint){
        return @"知识点";
    }else if (self.type == YXAnalysisAudioComment){
        return @"老师批语";
    }else if (self.type == YXAnalysisScore){
        return @"得分";
    }else if (self.type == YXAnalysisResult){
        return @"作答结果";
    }else if (self.type == YXAnalysisNote){
        return @"笔记";
    }else{
        return nil;
    }
}

@end

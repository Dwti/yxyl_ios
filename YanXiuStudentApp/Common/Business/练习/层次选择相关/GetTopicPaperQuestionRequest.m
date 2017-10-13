//
//  GetTopicPaperQuestionRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "GetTopicPaperQuestionRequest.h"

@implementation GetTopicPaperQuestionRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"/app/topic/getTopicPaperQuestion.do"];
    }
    return self;
}

- (void)dealWithResponseJson:(NSString *)json {
    NSString *decrypt = [YXCrypt decryptForString:json];
    if (!isEmpty(decrypt)) {
        [super dealWithResponseJson:decrypt];
    } else {
        [super dealWithResponseJson:json];
    }
}
@end

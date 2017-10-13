//
//  ResetTopicPaperHistoryRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

@interface ResetTopicPaperHistoryRequest : YXGetRequest
@property (nonatomic, copy) NSString *paperId;
@end

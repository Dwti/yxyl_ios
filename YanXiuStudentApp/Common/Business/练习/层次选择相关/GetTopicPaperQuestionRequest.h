//
//  GetTopicPaperQuestionRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXIntelligenceQuestionListItem.h"

@interface GetTopicPaperQuestionRequest : YXGetRequest
@property (nonatomic, copy) NSString *rmsPaperId;
@property (nonatomic, copy) NSString *type;
@end

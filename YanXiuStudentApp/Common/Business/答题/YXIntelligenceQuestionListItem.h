//
//  YXIntelligenceQuestionListItem.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/11/2.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "HttpBaseRequest.h"
#import "YXIntelligenceQuestion.h"
#import "YXCommonPageModel.h"

@interface YXIntelligenceQuestionListItem : HttpBaseRequestItem

@property (nonatomic, copy) YXCommonPageModel<Optional> *page;
@property (nonatomic, copy) NSArray<YXIntelligenceQuestion, Optional> *data;

@end

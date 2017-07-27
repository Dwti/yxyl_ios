//
//  YXMistakeContentChapterKnpViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 24/04/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"
#import "GetSubjectMistakeRequest.h"
#import "MistakePageListFetcher.h"
@class YXErrorsRequest;
@class YXIntelligenceQuestionListItem;

@interface YXMistakeContentChapterKnpViewController : QABaseViewController
@property (nonatomic, strong) YXQARequestParams *exeRequestParams;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
@property (nonatomic, strong) YXErrorsRequest *request;

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) MistakePageListFetcher *fetcher; // 用于做章节、知识点请求

@end

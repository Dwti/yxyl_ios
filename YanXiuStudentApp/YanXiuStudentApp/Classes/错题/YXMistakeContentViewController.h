//
//  YXMistakeContentViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXJieXiFoldUnfoldViewController.h"
#import "GetSubjectMistakeRequest.h"
#import "MistakePageListFetcher.h"
@class YXErrorsRequest;
@class YXIntelligenceQuestionListItem;

@interface YXMistakeContentViewController : YXJieXiFoldUnfoldViewController
@property (nonatomic, strong) YXQARequestParams *exeRequestParams;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
@property (nonatomic, strong) YXErrorsRequest *request;

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) MistakePageListFetcher *fetcher; // 用于做章节、知识点请求

@end

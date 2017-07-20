//
//  YXMistakeContentViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"
#import "GetSubjectMistakeRequest.h"
#import "MistakePageListFetcher.h"

@interface YXMistakeContentViewController : QABaseViewController
- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher;

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;

@end

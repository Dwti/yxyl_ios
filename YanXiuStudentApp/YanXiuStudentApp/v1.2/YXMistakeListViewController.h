//
//  YXMistakeListViewController.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "GetSubjectMistakeRequest.h"
@interface YXMistakeListViewController : PagedListViewControllerBase
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher;

@property (nonatomic, strong) UIButton *redoButton;
@end

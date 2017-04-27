//
//  MistakeAllViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "GetSubjectMistakeRequest.h"

@interface MistakeListViewController : PagedListViewControllerBase
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, strong) NSString *chapter_point_title; // 若不为空，则是由错题 章节、知识点进入的
@end

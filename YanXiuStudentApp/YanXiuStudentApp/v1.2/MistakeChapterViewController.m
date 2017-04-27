//
//  MistakeChapterViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeChapterViewController.h"
#import "ChapterTreeDataFetcher.h"
#import "ExerciseChapterTreeCell.h"
#import "YXGetSectionQBlockRequest.h"
#import "YXAnswerQuestionViewController.h"
#import "MistakeTreeCell.h"
#import "MistakeChapterTreeDataFetcher.h"
#import "MistakeChapterListRequest.h"
#import "MistakePageListFetcher.h"
#import "MistakeListViewController.h"
#import "YXMistakeListViewController.h"
#import "YXMistakeListWithoutRedoViewController.h"

@interface MistakeChapterViewController ()
@property (nonatomic, strong) YXGetSectionQBlockRequest *chapterRequest;
@end

@implementation MistakeChapterViewController

- (void)viewDidLoad {
    MistakeChapterTreeDataFetcher *fetcher = [[MistakeChapterTreeDataFetcher alloc] init];
    fetcher.subjectId = self.subjectID;
    fetcher.editionId = self.editionID;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    
    [self.treeView registerClass:[MistakeTreeCell class] forCellReuseIdentifier:@"MistakeTreeCell"];
    
    [self addNotification];
    
    self.emptyView.text = @"当前教材版本的章节目录下无题目";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification 
- (void)addNotification {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kDeleteMistakeSuccessNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        [self fetchTreeData];
        
    }];
}

#pragma mark - TreeView
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    BOOL isExpand = [treeView isCellForItemExpanded:item];
    
    MistakeChapterListRequestItem_chapter *chapter = item;
    
    MistakeTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"MistakeTreeCell"];
    cell.chapter = chapter;
    cell.level = level;
    cell.isExpand = isExpand;
    WEAK_SELF
    [cell setExpandBlock:^(MistakeTreeCell *cell) {
        STRONG_SELF
        if (cell.isExpand) {
            [self.treeView collapseRowForItem:item];
        }else {
            [self.treeView expandRowForItem:item];
        }
        cell.isExpand = !cell.isExpand;
    }];
    [cell setClickBlock:^(MistakeTreeCell *cell) {
        STRONG_SELF;
        [self requestMistakeListWithSubjectID:self.subjectID qids:cell.chapter.qids title:cell.chapter.name];
    }];
    
    return cell;
}

#pragma mark - request
- (void)requestMistakeListWithSubjectID:(NSString *)subjectID qids:(NSArray *)qids title:(NSString *)title {
    MistakePageListFetcher *fetcher = [[MistakePageListFetcher alloc] init];
    fetcher.subjectID = subjectID;
    fetcher.qids = qids;
    YXMistakeListWithoutRedoViewController *vc = [[YXMistakeListWithoutRedoViewController alloc] initWithFetcher:fetcher];
    vc.chapter_point_title = title;
    vc.subject = self.subject;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  MistakeKnpViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeKnpViewController.h"
#import "KnpTreeDataFetcher.h"
#import "GetKnpListRequest.h"
#import "ExerciseKnpTreeCell.h"
#import "YXGenKnpointQBlockRequest.h"
#import "YXAnswerQuestionViewController.h"
#import "MistakeTreeCell.h"
#import "MistakeKnpTreeDataFetcher.h"
#import "MistakeKnpListRequest.h"
#import "MistakePageListFetcher.h"
#import "MistakeListViewController.h"
#import "YXMistakeListWithoutRedoViewController.h"

@interface MistakeKnpViewController ()
@property (nonatomic, strong) YXGenKnpointQBlockRequest *knpQuestionRequest;
@end

@implementation MistakeKnpViewController

- (void)viewDidLoad {
    MistakeKnpTreeDataFetcher *fetcher = [[MistakeKnpTreeDataFetcher alloc] init];
    fetcher.subjectId = self.subjectID;
    fetcher.editionId = self.editionID;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    
    [self.treeView registerClass:[MistakeTreeCell class] forCellReuseIdentifier:@"MistakeTreeCell"];
    
    [self addNotification];
    
    self.emptyView.text = @"暂无题目";
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
    MistakeKnpListRequestItem_knp *knp = item;
    MistakeTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"MistakeTreeCell"];
    cell.knp = knp;
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
        STRONG_SELF
        [self requestMistakeListWithSubjectID:self.subjectID qids:cell.knp.qids title:cell.knp.name];
    }];
    return cell;
}

#pragma mark - request
- (void)requestMistakeListWithSubjectID:(NSString *)subjectID qids:(NSArray *)qids title:(NSString *)title {
    MistakePageListFetcher *fetcher = [[MistakePageListFetcher alloc] init];
    fetcher.subjectID = subjectID;
    fetcher.qids = qids;
    YXMistakeListWithoutRedoViewController *vc = [[YXMistakeListWithoutRedoViewController alloc] initWithFetcher:fetcher];
    vc.subject = self.subject;
    vc.chapter_point_title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

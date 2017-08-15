//
//  YXMistakeContentViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXMistakeContentViewController.h"
#import "YXDelMistakeRequest.h"
#import "YXQAAnalysisDataConfig.h"
#import "QAMistakeAnalysisDataConfig.h"

@interface YXMistakeContentViewController ()<QAAnalysisEditNoteDelegate>
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) PagedListFetcherBase *fetcher;
@property (nonatomic, strong) QAMistakeAnalysisDataConfig *analysisDataDelegate;
@end

@implementation YXMistakeContentViewController

- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher {
    if (self = [super init]) {
        self.fetcher = fetcher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"题目解析";
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"题目解析中删除错题icon正常态" highlightImageName:@"题目解析中删除错题icon点击态" action:^{
        STRONG_SELF
        [self requestForDeleteCurrentQuestion];
    }];
    
    [QAPaperModel resetIndexStringWithModel:self.model total:self.total];
    self.analysisDataDelegate = [[QAMistakeAnalysisDataConfig alloc]init];
    self.slideView.currentIndex = self.index;
    self.switchView.lastButtonHidden = YES;
    if (self.model.allQuestions.count == 1) {
        self.switchView.hidden = YES;
    }else {
        self.switchView.hidden = NO;
    }
}

#pragma mark - request
- (void)requestForDeleteCurrentQuestion {
    QAQuestion *item = [self.model.questions objectAtIndex:self.slideView.currentIndex];
    WEAK_SELF
    [self.view nyx_startLoading];
    [[MistakeQuestionManager sharedInstance] deleteMistakeQuestion:item completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self deleteQuestionsItem:self.slideView.currentIndex];
        
        self.total -= 1;
        self.subject.data.wrongQuestionsCount = [NSString stringWithFormat:@"%@", @(self.total)];
        [QAPaperModel resetIndexStringWithModel:self.model total:self.total];
        
        if (self.model.questions.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.slideView reloadData];
        }
    }];
}

- (void)requestForErrorsList {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    WEAK_SELF
    [self.fetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        self.isLoading = NO;
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        self.total = total;
        [self saveNewDatas:retItemArray];
    }];
}

#pragma mark - format data
- (void)saveNewDatas:(NSArray *)datas {
    NSMutableArray *questions = [[NSMutableArray alloc] initWithArray:self.model.questions];
    [questions addObjectsFromArray:datas];
    self.model.questions = questions;
    [QAPaperModel resetIndexStringWithModel:self.model total:self.total];
    [self.slideView reloadData];
}
- (void)deleteQuestionsItem:(NSInteger)integer {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:self.model.questions];
    [mutableArray removeObjectAtIndex:integer];
    self.model.questions = mutableArray;
}

- (BOOL)startPreLoading:(NSInteger)integer {
    if (integer >= self.model.questions.count - 2 && self.model.questions.count < self.total) {
        return YES;
    }
    else{
        return NO;
    }
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnalysisView];
    view.data = data;
    view.title = self.model.paperTitle;
    view.isSubQuestionView = NO;
    view.slideDelegate = self;
    view.editNoteDelegate = self;
    view.analysisDataDelegate = self.analysisDataDelegate;
    view.isPaperSubmitted = YES;
    
    return view;
}

#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [super slideView:slideView didSlideFromIndex:from toIndex:to];

    if ([self startPreLoading:to]) {
        [self requestForErrorsList];
    }
}

#pragma - QAAnalysisEditNoteDelegate
- (void)editNoteButtonTapped:(QAQuestion *)item {
    EditNoteViewController *vc = [[EditNoteViewController alloc] init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  YXMistakeContentViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXMistakeContentViewController.h"
#import "YXGetWrongQRequest.h"
#import "YXDelMistakeRequest.h"
#import "YXLoadingView.h"
#import "YXQAAnalysisDataConfig.h"
#import "QAMistakeAnalysisDataConfig.h"

@interface YXMistakeContentViewController ()
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation YXMistakeContentViewController

- (void)dealloc{
    DDLogWarn(@"release======>>%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.analysisDataDelegate = [[QAMistakeAnalysisDataConfig alloc] init];
    [self setupUI];
    self.slideView.currentIndex = self.index;
}

#pragma mark - setupUI
- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"删除icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"删除icon按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(naviRightAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button Action
- (void)naviRightAction:(UIButton *)sender {
    [self requestForDeleteCurrentQuestion];
}

#pragma mark - request
- (void)requestForDeleteCurrentQuestion {
    QAQuestion *item = [self.model.questions objectAtIndex:self.slideView.currentIndex];
    WEAK_SELF
    [self yx_startLoading];
    [[MistakeQuestionManager sharedInstance] deleteMistakeQuestion:item completeBlock:^(NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
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
    NSString *page = [NSString stringWithFormat:@"%@", @(self.curPage)];
    NSString *currentID = [self.model.questions.lastObject wrongQuestionID];
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance]requestMistakeListWithsubjectID:self.subject.subjectID page:page currentID:currentID completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        self.isLoading = NO;
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self saveNewDatas:item];
    }];
}

#pragma mark - format data
- (void)saveNewDatas:(YXIntelligenceQuestionListItem *)ret {
    NSArray *datas = [QAPaperModel modelFromRawData:ret.data[0]].questions;
    NSMutableArray *questions = [[NSMutableArray alloc] initWithArray:self.model.questions];
    [questions addObjectsFromArray:datas];
    self.model.questions = questions;
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
    QAQuestionBaseView *view = (QAQuestionBaseView *)[super slideView:slideView itemViewAtIndex:index];
    view.editNoteDelegate = self;
    return view;
}

#pragma mark - QASlideViewDelegate
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [QAPaperModel resetIndexStringWithModel:self.model total:self.total];

    if ([self startPreLoading:to]) {
        [self requestForErrorsList];
    }
}
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.model.questions.count;
}

#pragma mark - QAQuestionViewSlideDelegate
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question{
    [QAPaperModel resetIndexStringWithModel:self.model total:self.total];

    if (view != [self.slideView itemViewAtIndex:self.slideView.currentIndex]) {
        return;
    }
}


- (void)setFetcher:(MistakePageListFetcher *)fetcher {
    _fetcher = [[MistakePageListFetcher alloc] init];
    _fetcher.error = [fetcher.error copy];
    _fetcher.subjectID = [fetcher.subjectID copy];
    _fetcher.qids = [fetcher.qids copy];
    _fetcher.currentID = [fetcher.currentID copy];
}

@end

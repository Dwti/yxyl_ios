//
//  YXMyMistakeQAViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/27/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXCuoTiViewController_Pad.h"
#import "YXSlideView.h"
#import "YXQAMaterialView.h"

#import "YXGetWrongQRequest.h"
#import "YXDelMistakeRequest.h"
#import "YXLoadingView.h"
#import "YXErrorsRequest.h"

#import "YXQAAnalysisDataConfig.h"

@interface YXCuoTiViewController_Pad ()

@property (nonatomic, strong) YXErrorsRequest *request;
@property (nonatomic, strong) YXErrorsRequest *preRequest;
@property (nonatomic, strong) YXDelMistakeRequest *delRequest;

@end

@implementation YXCuoTiViewController_Pad

@synthesize dataArray = _dataArray;

#pragma mark- GetdataArray
- (void)newErrorsRequest
{
    self.request = [YXErrorsRequest new];
    self.request.currentPage = [NSString stringWithFormat:@"%d", self.curPage];
    self.request.pageSize = [NSString stringWithFormat:@"%d", self.pageSize];
    self.request.stageId = self.stageId;
    self.request.subjectId = self.subjectId;
    self.request.currentId = [self.model.questions.lastObject wrongQuestionID];
}

#pragma mark-
- (void)viewDidLoad {
    [super viewDidLoad];
    self.analysisDataDelegate = [[YXQAAnalysisDataConfig alloc] init];
    if (self.index) {
        self.slideView.currentIndex = self.index;
    }
}

#pragma mark- Set
- (void)setModel:(QAPaperModel *)model
{
    [super setModel:model];
    [self.slideView reloadData];
    [self.progressView updateWithIndex:0 total:self.total];
}

#pragma mark-
- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"删除icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"删除icon按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)naviRightAction {
    
    if ([[self.model.questions objectAtIndex:self.slideView.currentIndex] isKindOfClass:[NSString class]]) {
        return;
    }
    
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
    [self deleteCurrentQuestion];
}

- (void)yx_leftBackButtonPressed:(id)sender
{
    for (QAQuestion *item in self.model.questions) {
        
        if ([item isKindOfClass:[NSString class]]) {
            continue;
        }
    }
    [super yx_leftBackButtonPressed:sender];
}

- (void)deleteCurrentQuestion{
    QAQuestion *item = [self.model.questions objectAtIndex:self.slideView.currentIndex];
    @weakify(self);
    [self yx_startLoading];
    [self.delRequest stopRequest];
    self.delRequest = [[YXDelMistakeRequest alloc] init];
    self.delRequest.questionId = item.questionID;
    [self.delRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                             andCompleteBlock:^(id retItem, NSError *error) {
                                 @strongify(self); if (!self) return;
                                 for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                                     item.enabled = YES;
                                 }
                                 if (error && error.code != 69) {//69是已经删除成功了
                                     [self yx_stopLoading];
                                     if (!retItem) {
                                         [self yx_showToast:error.localizedDescription];
                                     }
                                     return;
                                 }
                                 
                                 NSMutableArray *questions = [self.model.questions mutableCopy];
                                 [questions removeObjectAtIndex:self.slideView.currentIndex];
                                 self.model.questions = questions;
                                 self.rawModel.data.wrongNum = [NSString stringWithFormat:@"%@", @(--self.total)];
                                 [self.slideView reloadData];
                                 [self.progressView updateWithIndex:self.slideView.currentIndex total:self.total];
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:YXDELETEERROR object:item userInfo:nil];
                                 [self yx_stopLoading];
                                 
                                 if ([self.model.questions count] == 0) {
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                                     return;
                                 }
                                 
                                 
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [self.progressView updateWithIndex:to total:self.total];
    QASlideItemBaseView *toView = [self.slideView itemViewAtIndex:to];
    [self updatePreNextButtonWithQuestionView:(QAQuestionBaseView *)toView];
    
    [self.request stopRequest];
    
    if (to == self.model.questions.count - 1 && to < self.total - 1) {
        if (self.isCache) {//读缓存
            YXIntelligenceQuestionListItem *item = [YXIntelligenceQuestionListItem new];
            YXIntelligenceQuestion *question = [YXIntelligenceQuestion new];
            question.paperTest = (NSArray <YXIntelligenceQuestion_PaperTest, Optional> *)[YXErrorsManager errorsWithPageSize:self.pageSize page:self.curPage stageId:self.stageId subjectId:self.subjectId];
            NSArray<YXIntelligenceQuestion, Optional> *data = (NSArray<YXIntelligenceQuestion, Optional> *)@[question];
            item.data = data;
            [self saveNewDatas:item];
        }else{
            [self newErrorsRequest];
            WEAK_SELF
            [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
                STRONG_SELF
                if (error) {
                    [self yx_showToast:error.localizedDescription];
                    return;
                }
                YXIntelligenceQuestionListItem *ret = retItem;
                [self saveNewDatas:ret];
                [YXErrorsManager saveErrors:[ret.data[0] paperTest] stageId:self.stageId subjectId:self.subjectId];
            }];
        }
    }
    
}

- (void)saveNewDatas:(YXIntelligenceQuestionListItem *)ret
{
    NSArray *datas = [QAPaperModel modelFromRawData:ret.data[0]].questions;
    NSMutableArray *questions = [self.model.questions mutableCopy];
    [questions addObjectsFromArray:datas];
    self.model.questions = questions;
    [self.slideView reloadData];
}

- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return self.model.questions.count;
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index{
    QAQuestionBaseView *view = (QAQuestionBaseView *)[super slideView:slideView itemViewAtIndex:index];
    return view;
}

#pragma mark - QAQuestionViewSlideDelegate
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question{
    if (view != [self.slideView itemViewAtIndex:self.slideView.currentIndex]) {
        return;
    }
    [self updatePreNextButtonWithQuestionView:view];
}
#pragma mark - Pad
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

@end

//
//  MistakeRedoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeRedoViewController.h"
#import "EditNoteViewController.h"
#import "MistakeQuestionSheetView.h"
#import "MistakeRedoReportView.h"
#import "MistakeRedoPageRequest.h"
#import "MistakeRedoCatalogRequest.h"
#import "MistakeQuestionManager.h"
#import "GlobalUtils.h"
#import "QAMistakeAnalysisDataConfig.h"
#import "SimpleAlertView.h"
#import "QARedoSubmitView.h"
#import "QAAnswerSheetViewController.h"
#import "MistakeSheetViewController.h"

@interface MistakeRedoViewController ()
@property (nonatomic, strong) SimpleAlertView *alertView;
@property (nonatomic, strong) MistakeRedoCatalogRequest *catalogRequest;
@property (nonatomic, strong) MistakeRedoCatalogRequestItem *catalogItem;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, assign) NSInteger requestingPage;
@property (nonatomic, strong) QAMistakeAnalysisDataConfig *analysisDataDelegate;
@property (nonatomic, strong) QARedoSubmitView *redoSubmitView;
@end

@implementation MistakeRedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.switchView.lastButtonHidden = YES;
    self.switchView.hidden = NO;
    self.title = @"重新做题";
    WEAK_SELF
    [self nyx_setupRightWithImageName:@"答题模块的答题卡图标正常态" highlightImageName:@"答题模块的答题卡图标点击态" action:^{
        STRONG_SELF
//        [self requestAndShowQuestionSheet];
        MistakeSheetViewController *vc = [[MistakeSheetViewController alloc]init];
        vc.model = self.model;
        WEAK_SELF
        [vc setSelectedActionBlock:^(QAQuestion *item) {
            STRONG_SELF
            [self.slideView scrollToItemIndex:item.position.firstLevelIndex animated:NO];
        }];
        [vc setBackActionBlock:^{
            STRONG_SELF
            self.slideView.isActive = YES;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.model updateToWholeModelWithQuestionTotalCount:self.qids.count currentOriIndex:0];
    
    [self.model.questions enumerateObjectsUsingBlock:^(QAQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.templateType!=YXQATemplateUnknown && !obj.redoCompleted) {
            self.slideView.currentIndex = idx;
            *stop = YES;
        }
    }];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [super setupUI];
    self.redoSubmitView = [[QARedoSubmitView alloc]init];
    [self.switchView addSubview:self.redoSubmitView];
    [self.redoSubmitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(130, 34));
    }];
}

#pragma mark - Actions
- (void)requestAndShowQuestionSheet {
    [self.view endEditing:YES];
//    if (self.catalogItem) {
//        [self showQuestionSheetWithItem:self.catalogItem];
//        return;
//    }
//    [self.catalogRequest stopRequest];
//    self.catalogRequest = [[MistakeRedoCatalogRequest alloc]init];
//    self.catalogRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
//    self.catalogRequest.subjectId = self.subject.subjectID;
//    NSString *qidsStr = [self.qids componentsJoinedByString:@","];
//    self.catalogRequest.qids = qidsStr;
//    WEAK_SELF
//    [self.view nyx_startLoading];
//    [self.catalogRequest startRequestWithRetClass:[MistakeRedoCatalogRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
//        STRONG_SELF
//        [self.view nyx_stopLoading];
//        if (error) {
//            [self.view nyx_showToast:error.localizedDescription];
//            return;
//        }
//        self.catalogItem = retItem;
//        [self showQuestionSheetWithItem:retItem];
//    }];
}

- (void)showQuestionSheetWithItem:(MistakeRedoCatalogRequestItem *)item {
    MistakeQuestionSheetView *sheetView = [[MistakeQuestionSheetView alloc]init];
    sheetView.model = self.model;
//    sheetView.item = item;
    WEAK_SELF
    [sheetView setSelectBlock:^(QAQuestion *question) {
        STRONG_SELF
        [self.slideView scrollToItemIndex:question.position.firstLevelIndex animated:NO];
        [self.alertView hide];
    }];
    [sheetView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    self.alertView = [[SimpleAlertView alloc]init];
    self.alertView.contentView = sheetView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
        }];
    }];
}

- (void)backAction {//本次需求不做练习报告的显示,点击返回直接返回错题列表-11.23
    [super backAction];
//    MistakeRedoReportView *reportView = [[MistakeRedoReportView alloc]init];
//    reportView.reportString = [self.model redoReportString];
//    WEAK_SELF
//    [reportView setContinueAction:^{
//        STRONG_SELF
//        [self.alertView hide];
//    }];
//    [reportView setExitAction:^{
//        STRONG_SELF
//        [self.alertView hide];
        [self reportRedoStatus];
//        [self updateRedoNote];
//    }];
//    self.alertView = [[SimpleAlertView alloc]init];
//    self.alertView.contentView = reportView;
//    [self.alertView show];
}

- (void)reportRedoStatus {
    QAQuestion *lastQ = nil;
    NSMutableArray *deletedIDs = [NSMutableArray array];
    for (QAQuestion *q in self.model.questions) {
        if (q.redoStatus == QARedoStatus_CanDelete) {
            lastQ = q;
        }else if (q.redoStatus == QARedoStatus_AlreadyDelete) {
            lastQ = q;
//            [deletedIDs addObject:q.wrongQuestionID];
            [deletedIDs addObject:q.questionID];
        }
    }
    if (!lastQ) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    WEAK_SELF
    [self.view nyx_startLoading];
    [[MistakeQuestionManager sharedInstance] deleteMistakeRedoQuestionWithDeletedIDs:deletedIDs completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }
        BLOCK_EXEC(self.updateNumberBlock,self.qids.count-deletedIDs.count);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateRedoNote {
    NSMutableArray *updatedQuestions = [NSMutableArray array];
    for (QAQuestion *q in self.model.questions) {
        if (q.childQuestions) {
            for (QAQuestion *cq in q.childQuestions) {
                if (!isEmpty(cq.noteText) || !isEmpty(cq.noteImages)) {
                    [updatedQuestions addObject:q];
                }
            }
        } else {
            if (!isEmpty(q.noteText) || !isEmpty(q.noteImages)) {
                [updatedQuestions addObject:q];
            }
        }
    }
    BLOCK_EXEC(self.updateNoteBlock, updatedQuestions);
}

#pragma mark - slide tab datasource delegate
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionRedoView];
    view.data = data;
    view.isPaperSubmitted = YES;
    view.title = self.model.paperTitle;
    view.isSubQuestionView = NO;
    view.analysisDataDelegate = self.analysisDataDelegate;
    view.editNoteDelegate = self;
    
    return view;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [super slideView:slideView didSlideFromIndex:from toIndex:to];
    QAQuestionBaseView *currentView = (QAQuestionBaseView *)[slideView itemViewAtIndex:slideView.currentIndex];
    QAQuestion *currentQuestion = self.model.questions[to];
    if (currentView.oriData != currentQuestion) { // 数据更新时刷新界面
        [self.slideView reloadData];
    }else if (currentQuestion.templateType == YXQATemplateUnknown) { // 无数据时进行请求
        [self requestDataFromIndex:to];
    }
    self.redoSubmitView.question = self.model.questions[to];
}

- (void)requestDataFromIndex:(NSInteger)index {
    // 已经在请求则不做处理
    if (self.isRequesting && [self isIndexInRequestRange:index]) {
        return;
    }
    self.isRequesting = YES;
    self.requestingPage = index/kRedoPageSize;
    NSUInteger length = MIN(10, (self.qids.count - self.requestingPage * 10));
    NSUInteger loc = self.requestingPage * 10;
    NSArray *qids = [self.qids subarrayWithRange:NSMakeRange(loc, length)];
    NSString *qidsStr = [qids componentsJoinedByString:@","];
    [self.view nyx_startLoading];
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance] requestMistakeRedoPageWithSubjectID:self.subject.subjectID qid:qidsStr completeBlock:^(QAPaperModel *model, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.isRequesting = NO;
        QAQuestion *currentQuestion = self.model.questions[self.slideView.currentIndex];
        if (error) {
            if (currentQuestion.templateType == YXQATemplateUnknown) {
                [self.view nyx_showToast:error.localizedDescription];
            }
            return;
        }
        NSInteger position = (self.requestingPage)*kRedoPageSize;
        [self.model replaceQuestions:model.questions fromIndex:position];
        if (currentQuestion.templateType == YXQATemplateUnknown) {
            [self.slideView reloadData];
        }
    }];
}

- (BOOL)isIndexInRequestRange:(NSInteger)index {
    NSInteger from = (self.requestingPage-1)*kRedoPageSize;
    NSInteger to = from+kRedoPageSize-1;
    if (index>=from && index<=to) {
        return YES;
    }
    return NO;
}

#pragma - QAAnalysisEditNoteDelegate
- (void)editNoteButtonTapped:(QAQuestion *)item {
    EditNoteViewController *vc = [[EditNoteViewController alloc] init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (QAMistakeAnalysisDataConfig *)analysisDataDelegate {
    if (!_analysisDataDelegate) {
        _analysisDataDelegate = [[QAMistakeAnalysisDataConfig alloc]init];
    }
    return _analysisDataDelegate;
}

@end

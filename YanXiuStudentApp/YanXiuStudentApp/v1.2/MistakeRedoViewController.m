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

@interface MistakeRedoViewController ()<QAAnalysisEditNoteDelegate>
@property (nonatomic, strong) SimpleAlertView *alertView;
@property (nonatomic, strong) MistakeRedoCatalogRequest *catalogRequest;
@property (nonatomic, strong) MistakeRedoCatalogRequestItem *catalogItem;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, assign) NSInteger requestingPage;
@property (nonatomic, strong) QAMistakeAnalysisDataConfig *analysisDataDelegate;
@end

@implementation MistakeRedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.model updateToWholeModelWithQuestionTotalCount:self.totalNumber currentOriIndex:self.model.questions.firstObject.wrongQuestionIndex-1];
    
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

- (void)setupTitle{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"重新做题"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(146, 40));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"重新做题";
    label.font = [UIFont fontWithName:YXFontMetro_Bold size:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    label.layer.shadowRadius = 0;
    label.layer.shadowOffset = CGSizeMake(0, 2);
    label.layer.shadowOpacity = 1;
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(2);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupMaskView{
    UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage yx_resizableImageNamed:@"错题重做遮罩"]];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 10, 32, 17));
    }];
}

- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"答题卡"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"答题卡-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(requestAndShowQuestionSheet) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions
- (void)requestAndShowQuestionSheet {
    [self.view endEditing:YES];
    if (self.catalogItem) {
        [self showQuestionSheetWithItem:self.catalogItem];
        return;
    }
    [self.catalogRequest stopRequest];
    self.catalogRequest = [[MistakeRedoCatalogRequest alloc]init];
    self.catalogRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.catalogRequest.subjectId = self.subject.subjectID;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.catalogRequest startRequestWithRetClass:[MistakeRedoCatalogRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        self.catalogItem = retItem;
        [self showQuestionSheetWithItem:retItem];
    }];
}

- (void)showQuestionSheetWithItem:(MistakeRedoCatalogRequestItem *)item {
    MistakeQuestionSheetView *sheetView = [[MistakeQuestionSheetView alloc]init];
    sheetView.model = self.model;
    sheetView.item = item;
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

- (void)yx_leftBackButtonPressed:(id)sender {
    MistakeRedoReportView *reportView = [[MistakeRedoReportView alloc]init];
    reportView.reportString = [self.model redoReportString];
    WEAK_SELF
    [reportView setContinueAction:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [reportView setExitAction:^{
        STRONG_SELF
        [self.alertView hide];
        [self reportRedoStatus];
        [self updateRedoNote];
    }];
    self.alertView = [[SimpleAlertView alloc]init];
    self.alertView.contentView = reportView;
    [self.alertView show];
}

- (void)reportRedoStatus {
    QAQuestion *lastQ = nil;
    NSMutableArray *deletedIDs = [NSMutableArray array];
    for (QAQuestion *q in self.model.questions) {
        if (q.redoStatus == QARedoStatus_CanDelete) {
            lastQ = q;
        }else if (q.redoStatus == QARedoStatus_AlreadyDelete) {
            lastQ = q;
            [deletedIDs addObject:q.wrongQuestionID];
        }
    }
    if (!lastQ) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance] deleteMistakeRedoQuestion:lastQ subjectId:self.subject.subjectID deletedIDs:deletedIDs completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }
        BLOCK_EXEC(self.updateNumberBlock,self.totalNumber-deletedIDs.count);
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
    if (currentView.data != currentQuestion) { // 数据更新时刷新界面
        [self.slideView reloadData];
    }else if (currentQuestion.templateType == YXQATemplateUnknown) { // 无数据时进行请求
        [self requestDataFromIndex:to];
    }
}

- (void)requestDataFromIndex:(NSInteger)index {
    // 已经在请求则不做处理
    if (self.isRequesting && [self isIndexInRequestRange:index]) {
        return;
    }
    self.isRequesting = YES;
    self.requestingPage = index/kRedoPageSize+1;
    NSString *page = [NSString stringWithFormat:@"%@",@(self.requestingPage)];
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance]requestMistakeRedoPageWithSubjectID:self.subject.subjectID page:page completeBlock:^(QAPaperModel *model, NSError *error) {
        STRONG_SELF
        self.isRequesting = NO;
        QAQuestion *currentQuestion = self.model.questions[self.slideView.currentIndex];
        if (error) {
            if (currentQuestion.templateType == YXQATemplateUnknown) {
                [self.view nyx_showToast:error.localizedDescription];
            }
            return;
        }
        NSInteger position = (self.requestingPage-1)*kRedoPageSize;
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

@end

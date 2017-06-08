//
//  YXAnswerQuestionViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/14/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXJieXiViewController.h"
#import "YXAutoGoNextDelegate.h"

#import "YXQAReportViewController.h"

#import "YXAnswerQuestionViewController.h"

#import "YXJieXiReportErrorDelegate.h"
#import "YXReportErrorViewModel.h"
#import "YXReportErrorViewController.h"
#import "YXPhotoBrowser.h"
#import "YXGenKnpointQBlockRequest.h"

@interface YXJieXiViewController () <YXQASubjectiveAddPhotoHandlerDelegate,QAQuestionViewSlideDelegate>
@property (nonatomic, strong) YXGenKnpointQBlockRequest *knpQuestionRequest;

@end

@implementation YXJieXiViewController
#pragma mark- Get
- (id<YXQAAnalysisDataDelegate>)analysisDataDelegate
{
    if (!_analysisDataDelegate) {
        _analysisDataDelegate = [[YXQAAnalysisDataConfig alloc]init];
    }
    return _analysisDataDelegate;
}

#pragma mark-
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupBG];
    [self setupTitle];
    [self yx_setupLeftBackBarButtonItem];
    if (self.pType == YXPTypeIntelligenceExercise || self.pType == YXPTypeExerciseHistory){
        [self setupRight];
    }
    
    [self _setupSlideForQA];
    [self setupMaskView];
    self.addPhotoHandler = [[YXQASubjectiveAddPhotoHandler alloc]initWithViewController:self];
    self.addPhotoHandler.delegate = self;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)setupBG{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"桌面"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UIImage *bookImage = [UIImage imageNamed:@"book"];
    bookImage = [bookImage stretchableImageWithLeftCapWidth:50 topCapHeight:50];
    UIImageView *bookImageView = [[UIImageView alloc]initWithImage:bookImage];
    bookImageView.userInteractionEnabled = YES;
    [self.view addSubview:bookImageView];
    [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 0, 3, 2));
    }];
}

- (void)setupTitle{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"解析标题背景"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(146, 40));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"006666"];
    label.text = @"题目解析";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.shadowColor = [UIColor colorWithHexString:@"33ffff"].CGColor;
    label.layer.shadowRadius = 0;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(2);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-12);
    }];
}

- (void)setupRight{
  
}

- (void)yx_setupLeftBackBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 - 28);
        make.top.mas_equalTo(26 - 28);
        make.size.mas_equalTo(CGSizeMake(28*3, 28*3));
    }];
    [button addTarget:self action:@selector(yx_leftBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)yx_leftBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviRightAction {

}

- (void)_setupSlideForQA {
    self.slideView = [[QASlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(26+40);
        make.bottom.mas_equalTo(-29-3);
    }];
    self.slideView.currentIndex = self.firstLevel;
}

- (void)setupMaskView{
    UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage stretchImageNamed:@"遮罩"]];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 10, 30, 17));
    }];
}

#pragma mark - slide tab datasource delegate

- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return [self.model.questions count];
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnalysisView];
    view.data = data;
    view.isPaperSubmitted = [self.model isPaperSubmitted];
    view.title = self.model.paperTitle;
    view.isSubQuestionView = NO;
    view.addPhotoHandler = self.addPhotoHandler;
    view.slideDelegate = self;
    view.photoDelegate = self.addPhotoHandler;
    view.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
    view.pointClickDelegate = self;
    view.reportErrorDelegate = self;
    view.editNoteDelegate = self;
    view.analysisDataDelegate = self.analysisDataDelegate;
    if (index == self.firstLevel) {
        if (self.secondLevel >= 0) {
            view.nextLevelStartIndex = self.secondLevel;
            self.secondLevel = -1;
        }
    }
    
    return view;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to{
    if (to >= [self.model.questions count]) {
        return;
    }
    QAQuestion *item = self.model.questions[to];
    if (item.isFavorite) {
        [self setupRightFavorStatus:YES];
    }else{
        [self setupRightFavorStatus:NO];
    }
    // 复合题滑出当前页时要把小题索引设为0
    QASlideItemBaseView *view = [self.slideView itemViewAtIndex:from];
    if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]] && from != to) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
        if (complexView.slideView.currentIndex != 0) {
            [complexView.slideView scrollToItemIndex:0 animated:NO];
        }
    }
}

- (void)setupRightFavorStatus:(BOOL)isFavor{
  
}

#pragma mark - QAQuestionViewSlideDelegate
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question{
    if (view != [self.slideView itemViewAtIndex:self.slideView.currentIndex]) {
        return;
    }
}

#pragma mark - YXQAAnalysisKnpClickDelegate
- (void)knpClickedWithID:(NSString *)knpID{
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    
    YXQARequestParams *params = [[YXQARequestParams alloc] init];
    params.subjectId = self.requestParams.subjectId;
    params.stageId = self.requestParams.stageId;
    params.type = self.requestParams.type;
    params.segment = YXExerciseListSegmentTestItem;
    params.questNum = self.requestParams.questNum;
    params.fromType = @"1";
    params.chapterId = knpID;
    params.sectionId = nil;
    params.cellId = nil;

    [self.knpQuestionRequest stopRequest];
    self.knpQuestionRequest = [[YXGenKnpointQBlockRequest alloc] init];
    self.knpQuestionRequest.stageId = params.stageId;
    self.knpQuestionRequest.subjectId = params.subjectId;
    self.knpQuestionRequest.questNum = params.questNum;
    self.knpQuestionRequest.knpId1 = params.chapterId;
    self.knpQuestionRequest.knpId2 = params.sectionId;
    self.knpQuestionRequest.knpId3 = params.cellId;
    self.knpQuestionRequest.fromType = params.fromType;
    WEAK_SELF
    [self.knpQuestionRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXIntelligenceQuestionListItem *item = retItem;
        YXIntelligenceQuestion *question = nil;
        if (item.data.count > 0) {
            question = item.data[0];
            YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
            vc.requestParams = params;
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.pType = self.pType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

#pragma mark YXQAAnalysisReportErrorDelegate

- (void)reportAnalysisErrorWithID:(NSString *)qid
{
    YXReportErrorViewModel * viewModel = [[YXReportErrorViewModel alloc] init];
    viewModel.quesId = qid;
    YXReportErrorViewController * viewController = [[YXReportErrorViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)canReportError{
    return YES;
}

#pragma mark - YXQASubjectiveAddPhotoHandlerDelegate
- (MWPhotoBrowser *)photoBrowserWithTitle:(NSString *)title currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    YXPhotoBrowser * photoBrowser = [[YXPhotoBrowser alloc] initWithDelegate:self.addPhotoHandler];
    photoBrowser.title = title;
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = YES;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser hiddenRightBarButtonItem:!canDelete];
    @weakify(self);
    photoBrowser.deleteHandle = ^(){
        @strongify(self);
        [self.addPhotoHandler showDeleteActionSheet];
    };
    return photoBrowser;
}

#pragma - QAAnalysisEditNoteDelegate
- (void)editNoteButtonTapped:(QAQuestion *)item {
    EditNoteViewController *vc = [[EditNoteViewController alloc] init];
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

@end


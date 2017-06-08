////  YXAnswerQuestionViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/14/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXAnswerQuestionViewController.h"
#import "QASlideView.h"

#import "YXQAReportViewController.h"
#import "YXGetQuestionReportRequest.h"
#import "YXIntelligenceQuestion.h"
#import "YXJieXiViewController.h"
#import "YXCommonButton.h"
#import "YXQASheetView.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "YXQASubjectiveAddPhotoHandler.h"
#import "YXQATimer.h"
#import "YXPhotoListViewController.h"
#import "YXPhotoBrowser.h"
#import "YXQASubmitSuccessView_Phone.h"
#import "YXQASubmitSuccessAndBackView_Phone.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"
#import "FLAnimatedImage.h"
#import "ImageUploadProgressView.h"

#define kInstructionKey @"yxqa_instruction_key"


@interface YXAnswerQuestionViewController () <QASlideViewDataSource, QASlideViewDelegate, YXAutoGoNextDelegate,YXQASheetViewDelegate,YXQASubjectiveAddPhotoHandlerDelegate,QAQuestionViewSlideDelegate>
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) QASlideView *slideView;
@property (nonatomic, strong) YXQASheetView *sheetView;
@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, assign) BOOL showComplex;
@property (nonatomic, assign) BOOL showClassify;
@property (nonatomic, strong) ImageUploadProgressView *uploadImageView;
@end

@implementation YXAnswerQuestionViewController

- (void)dealloc {
    [YXQATimer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBG];
    [self yx_setupLeftBackBarButtonItem];
    [self setupRight];
    [self setupClock];

    [self _setupSlideForQA];
    [self setupMaskView];
    self.beginDate = [NSDate date];
    self.addPhotoHandler = [[YXQASubjectiveAddPhotoHandler alloc]initWithViewController:self];
    self.addPhotoHandler.delegate = self;
    
    [YXRecordManager addRecordWithType:YXRecordPractiseType];
    
    self.showComplex = NO;
    self.showClassify = NO;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self tipsForAnswerQuestion];
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (![vc isKindOfClass:[YXQAReportViewController class]]&&![vc isKindOfClass:[YXJieXiViewController class]]) {
            [vcArray addObject:vc];
        }
    }
    self.navigationController.viewControllers = vcArray;
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

- (void)setupClock{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"计时器"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(146, 40));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"00:00";
    label.font = [UIFont fontWithName:YXFontMetro_Bold size:20];
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
    }];
    self.timeLabel = label;
    WEAK_SELF
    [YXQATimer sharedInstance].timePassed = self.model.paperAnswerDuration;
    [YXQATimer startWithInterval:1 triggerBlock:^(NSString *timeUsedString) {
        STRONG_SELF
        label.text = timeUsedString;
        self.model.paperAnswerDuration = [YXQATimer sharedInstance].timePassed;
    }];
}

- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"提交icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"提交icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)yx_setupLeftBackBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-6);
        make.top.mas_equalTo(10);
        make.width.height.offset = 60;
//        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [button addTarget:self action:@selector(yx_leftBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    self.slideView.currentIndex = 0;
    
#ifdef DEBUG
    [self addTestQidButton];
#endif
 
}

- (void)setupMaskView{
    UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage stretchImageNamed:@"遮罩"]];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 10, 30, 17));
    }];
}

- (void)addTestQidButton
{
    YXCommonButton *button = [[YXCommonButton alloc] init];
    [button setTitle:@"答案" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-70);
    }];
}

- (void)buttonClick
{
    if (self.slideView.currentIndex >= self.model.questions.count) {
        return;
    }
    NSString *answer = @"";
    QAQuestion *item = self.model.questions[self.slideView.currentIndex];
    if (item.templateType == YXQATemplateSingleChoose||
        item.templateType == YXQATemplateMultiChoose||
        item.templateType == YXQATemplateFill||
        item.templateType == YXQATemplateYesNo) {
        for (NSString *string in item.correctAnswers) {
            answer = [NSString stringWithFormat:@"%@ %@", answer, string];
        }

        EEAlertView *alertView = [[EEAlertView alloc] init];
        alertView.title = answer;
        [alertView show];
        
    }
}

#pragma mark - Navi Action
- (void)yx_leftBackButtonPressed:(id)sender
{
    self.slideView.isActive = NO;
    
    BOOL unAnswered = TRUE;
    for (QAQuestion *item in [self.model allQuestions]) {
        if (item.answerState != YXAnswerStateNotAnswer) {
            unAnswered = FALSE;
            break;
        }
    }
    if (self.model.paperStatusID) {
        unAnswered = FALSE;
    }
    if (unAnswered) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.pType == YXPTypeGroupHomework) {
        [self saveAndQuit];
        return;
    }
    
    WEAK_SELF
    EEAlertView *alert = [[EEAlertView alloc] init];
    alert.title = @"离开后，您可以在练习历史中找到记录并继续答题";
    
    [alert addButtonWithTitle:@"取消" action:^{
        STRONG_SELF
        self.slideView.isActive = YES;
    }];
    [alert addButtonWithTitle:@"离开" action:^{
        STRONG_SELF
        [self saveAndQuit];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)saveAndQuit {
    if (![self isNetworkReachable]) {
        WEAK_SELF
        EEAlertView *alert = [[EEAlertView alloc] init];
        alert.title = @"当前网络异常，退出答题进度将无法保存";
        [alert addButtonWithTitle:@"取消" action:^{
            STRONG_SELF
            self.slideView.isActive = YES;
        }];
        [alert addButtonWithTitle:@"继续退出" action:^{
            STRONG_SELF
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showInView:self.navigationController.view];
        return;
    }

    [self setupUploadImageViewWithType:ImageUpload_Save];
    WEAK_SELF
    [[YXQADataManager sharedInstance]savePaperToHistoryWithModel:self.model beginDate:self.beginDate completeBlock:^(NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self.uploadImageView removeFromSuperview];
            [self handleSaveFailure];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupUploadImageViewWithType:(ImageUploadType)type {
    self.uploadImageView = [[ImageUploadProgressView alloc]init];
    self.uploadImageView.type = type;
    WEAK_SELF
    [self.uploadImageView setupCloseBlock:^{
        STRONG_SELF
        [[YXQADataManager sharedInstance]stopSubmitPaper];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.uploadImageView];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[YXQADataManager sharedInstance]setUploadImageBlock:^(NSInteger index, NSInteger total) {
        STRONG_SELF
        if (index == total) {
            [self.uploadImageView removeFromSuperview];
            [self yx_startLoading];
            return;
        }
        [self.uploadImageView updateWithUploadedCount:index totalCount:total];
    }];
}

- (void)handleSaveFailure {
    WEAK_SELF
    EEAlertView *alert = [[EEAlertView alloc] init];
    alert.title = @"保存失败，请检查网络后重试";
    [alert addButtonWithTitle:@"取消" action:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addButtonWithTitle:@"再试一次" action:^{
        STRONG_SELF
        [self saveAndQuit];
    }];
    [alert showInView:self.view];
}

- (void)naviRightAction {
    DDLogWarn(@"答题卡页");
    self.slideView.isActive = NO;
    [self popupFinalSheet];
}
- (void)popupFinalSheet{
    YXQASheetView *sheetView = [[YXQASheetView alloc]initWithFrame:self.view.bounds];
    sheetView.model = self.model;
    sheetView.delegate = self;
    [sheetView showInView:self.view];
    self.sheetView = sheetView;
}

#pragma mark - Methods
- (void)submitPaper {
    if ([self.sheetView bAllHasAnswer]) {
        [self goReport];
        return;
    }
    @weakify(self);
    EEAlertView *alert = [[EEAlertView alloc] init];
    alert.title = @"还有未做完的题目，确定提交吗?";
    [alert addButtonWithTitle:@"取消" action:^{
        @strongify(self);
        self.slideView.isActive = YES;
    }];
    [alert addButtonWithTitle:@"提交" action:^{
        @strongify(self);
        [self goReport];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)goReport {
    if (![self isNetworkReachable]) {
        [self yx_showToast:@"网络异常，请检查网络后重试"];
        self.slideView.isActive = YES;
        return;
    }
    [self setupUploadImageViewWithType:ImageUpload_Submit];
    WEAK_SELF
    [[YXQADataManager sharedInstance]submitPaperWithModel:self.model beginDate:self.beginDate requestParams:self.requestParams completeBlock:^(NSError *error, QAPaperModel *reportModel) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self.uploadImageView removeFromSuperview];
            [self handleSubmitFailure:error];
        }else{
            
            YXProblemItem *item = [YXProblemItem new];
            item.paperType      = @(self.pType == YXPTypeGroupHomework? 1: 0);
            item.editionID      = self.requestParams.editionId;
            item.subjectID      = self.requestParams.subjectId;
            item.quesNum        = self.sheetView.wrote.length? self.sheetView.wrote: @"0";
            item.gradeID        = self.model.gradeID;
            item.type           = YXRecordSubmitWorkType;
            NSMutableArray *questions = [NSMutableArray new];
            for (QAQuestion *question in self.model.questions) {
                [questions addObject:question.questionID];
            }
            item.questionID = questions;
            [YXRecordManager addRecord:item];
            
            if (self.pType == YXPTypeGroupHomework && !reportModel.canShowHomeworkAnalysis) {
                YXQASubmitSuccessAndBackView_Phone *backView = [[YXQASubmitSuccessAndBackView_Phone alloc]init];
                backView.endDate = reportModel.homeworkEndDate;
                WEAK_SELF
                backView.actionBlock = ^{
                    STRONG_SELF
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.view addSubview:backView];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
                return;
            }
            if (self.pType != YXPTypeGroupHomework) {
                [YXQADataManager sharedInstance].hasDoExerciseToday = YES;
            }
            YXQASubmitSuccessView_Phone *successView = [[YXQASubmitSuccessView_Phone alloc]init];
            successView.pType = self.pType;
            WEAK_SELF
            successView.actionBlock = ^{
                STRONG_SELF
                YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
                vc.model = reportModel;
                vc.requestParams = self.requestParams;
                vc.pType = self.pType;
                vc.canDoExerciseAgain = self.pType == YXPTypeIntelligenceExercise? YES:NO;
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.view addSubview:successView];
            [successView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
    }];
}

- (void)handleSubmitFailure:(NSError *)error {
    if ([self isNetworkReachable]) {
        [self yx_showToast:error.localizedDescription];
        self.slideView.isActive = YES;
        return;
    }
    WEAK_SELF
    EEAlertView *alert = [[EEAlertView alloc] init];
    alert.title = @"作业上传失败，请检查网络后重试";
    [alert addButtonWithTitle:@"取消" action:^{
        STRONG_SELF
        self.slideView.isActive = YES;
    }];
    [alert addButtonWithTitle:@"再试一次" action:^{
        STRONG_SELF
        [self goReport];
    }];
    [alert showInView:self.view];
}

- (void)slideToQAItem:(QAQuestion *)item {
    [self.slideView scrollToItemIndex:item.position.firstLevelIndex animated:NO];
    QAComlexQuestionAnswerBaseView *mv = (QAComlexQuestionAnswerBaseView *)[self.slideView itemViewAtIndex:self.slideView.currentIndex];
    if ([mv isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        mv.nextLevelStartIndex = item.position.secondLevelIndex;
        [mv.slideView scrollToItemIndex:item.position.secondLevelIndex animated:NO];
    }
}


#pragma mark - Tips for first display
- (void)tipsForAnswerQuestion {
    if (![YXQADataManager sharedInstance].qaHasEnteredBefore) {
        [self showTipsWithName:@"出题动画"];
        [YXQADataManager sharedInstance].qaHasEnteredBefore = YES;
    }
}

- (void)tipsForTemplateClassify {
    if (![YXQADataManager sharedInstance].qaHasEnteredClassify) {
        [self showTipsWithName:@"归类动画"];
        [YXQADataManager sharedInstance].qaHasEnteredClassify = YES;
    }
}

- (void)tipsForTemplateComplex {
    if (![YXQADataManager sharedInstance].qaHasEnteredComplex) {
        [self showTipsWithName:@"复合动画"];
        [YXQADataManager sharedInstance].qaHasEnteredComplex = YES;
    }
}

- (void)showTipsWithName:(NSString *)name {
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTips:)];
    [maskView addGestureRecognizer: tap];
    
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    imageView.center = self.view.center;
    [maskView addSubview:imageView];

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"gif"]]];
    imageView.animatedImage = image;
}

- (void)hideTips:(UIGestureRecognizer *)tap {
    UIView *maskView = tap.view;
    
    [UIView animateWithDuration:0.3f animations:^{
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
        
        // avoid showign two git at the same time
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (self.showComplex) {
                self.showComplex = NO;
                [self tipsForTemplateComplex];
            } else if (self.showClassify) {
                self.showClassify = NO;
                [self tipsForTemplateClassify];
            }
        });
    }];
}

#pragma mark - slide tab datasource delegate

- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return [self.model.questions count];
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnswerView];
    view.data = data;
    view.isPaperSubmitted = [self.model isPaperSubmitted];
    view.isSubQuestionView = NO;
    view.addPhotoHandler = self.addPhotoHandler;
    view.delegate = self;
    view.slideDelegate = self;
    view.photoDelegate = self.addPhotoHandler;
    
    return view;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to{
    // 复合题滑出当前页时要把小题索引设为0
    QASlideItemBaseView *view = [self.slideView itemViewAtIndex:from];
    if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]] && from != to) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
        if (complexView.slideView.currentIndex != 0) {
            [complexView.slideView scrollToItemIndex:0 animated:NO];
        }
    }
    
    // 复合题 归类题引导
    QASlideItemBaseView *toView = [self.slideView itemViewAtIndex:to];
    if ([toView isKindOfClass:[QAClassifyQuestionView class]]) {
        if (![YXQADataManager sharedInstance].qaHasEnteredBefore) {
            self.showClassify = YES;
        } else {
            [self tipsForTemplateClassify];
        }
    }
    if ([toView isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        if (![YXQADataManager sharedInstance].qaHasEnteredBefore) {
            self.showComplex = YES;
        } else {
            [self tipsForTemplateComplex];
        }
    }
}


- (void)slideViewDidReachMostRight:(QASlideView *)slideView{
    QASlideItemBaseView *view = [self.slideView itemViewAtIndex:slideView.currentIndex];
    if ([view isKindOfClass:[QAComlexQuestionAnswerBaseView class]]) {
        QAComlexQuestionAnswerBaseView *complexView = (QAComlexQuestionAnswerBaseView *)view;
        CGPoint p = [slideView.panGesture locationInView:complexView.slideView];
        if (CGRectContainsPoint(complexView.slideView.bounds, p)) {
            if (complexView.slideView.currentIndex != complexView.data.childQuestions.count-1) {
                return;
            }
        }
    }
    if (!self.sheetView.superview) {
        [self naviRightAction];
    }
}

#pragma mark - QAQuestionViewSlideDelegate
- (void)questionView:(QAQuestionBaseView *)view didSlideToChildQuestion:(QAQuestion *)question{
    if (view != [self.slideView itemViewAtIndex:self.slideView.currentIndex]) {
        return;
    }
}

#pragma mark - YXAutoGoNextDelegate
- (void)autoGoNextGoGoGo {
    if (self.slideView.currentIndex == self.model.questions.count-1) {
        [self naviRightAction];
        return;
    }
    [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
}


#pragma mark - YXQASheetViewDelegate
- (void)sheetViewDidSelectItem:(QAQuestion *)item{
    self.slideView.isActive = YES;
    [self slideToQAItem:item];
}

- (void)sheetViewDidSubmit{
    [self submitPaper];
}

- (void)sheetViewDidCancel{
    self.slideView.isActive = YES;
}

#pragma mark - YXQASubjectiveAddPhotoHandlerDelegate
- (UIViewController *)photoListVCWithViewModel:(YXAlbumViewModel *)viewModel title:(NSString *)title{
    UIViewController *viewController = [[YXPhotoListViewController alloc] initWithViewModel:viewModel];
    
    viewController.title = title;
    UINavigationController *navi = [[YXNavigationController alloc]initWithRootViewController:viewController];
    return navi;
}

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
@end


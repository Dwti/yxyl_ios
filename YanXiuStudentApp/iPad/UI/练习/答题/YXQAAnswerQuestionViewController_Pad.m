//
//  YXQAAnswerQuestionViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXQAProgressView_Pad.h"
#import "YXQASheetView_Pad.h"
#import "YXAutoGoNextDelegate.h"
#import "YXQASingleChooseView_Pad.h"
#import "YXQAMultiChooseView_Pad.h"
#import "YXQAYesNoView_Pad.h"
#import "YXQAFillBlankView_Pad.h"
#import "YXQAMaterialView_Pad.h"
#import "YXQASubjectiveView_Pad.h"
#import "UIView+YXScale.h"
#import "YXCommonLabel.h"
#import "YXQAAnalysisViewController_Pad.h"
#import "YXQAReportViewController_Pad.h"
#import "YXQATimer.h"
#import "YXCommonButton.h"
#import "YXAlertView+YXConfirmMethod.h"
#import "YXSplitViewController.h"
#import "YXSideMenuCopyrightView_Pad.h"
#import "YXQASubjectiveAddPhotoHandler.h"
#import "YXPhotoListViewController_Pad.h"
#import "YXNavigationController_Pad.h"
#import "YXPhotoBrowser_Pad.h"
#import "YXQASubmitSuccessView_Pad.h"
#import "YXQASubmitSuccessAndBackView_Pad.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"

@interface YXQAAnswerQuestionViewController_Pad ()<YXSlideViewDataSource, YXSlideViewDelegate, YXAutoGoNextDelegate,YXQASheetViewDelegate,YXQASubjectiveAddPhotoHandlerDelegate>
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) UIView *bookView;
@property (nonatomic, strong) YXSlideView *slideView;
@property (nonatomic, strong) YXQASheetView_Pad *sheetView;
@property (nonatomic, strong) YXQAProgressView_Pad *progressView;
@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;

@end

@implementation YXQAAnswerQuestionViewController_Pad

- (void)dealloc{
    [YXQATimer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBG];
    [self setupClock];
    [self setupLeft];
    [self setupRight];
    [self setupSlideForQA];
    [self setupMaskView];
    [self setupPencilAndEraser];
    self.beginDate = [NSDate date];
    self.addPhotoHandler = [[YXQASubjectiveAddPhotoHandler alloc]initWithViewController:self];
    self.addPhotoHandler.delegate = self;
    [YXRecordManager addRecordWithType:YXRecordPractiseType];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![YXQADataManager sharedInstance].qaHasEnteredBefore)
    {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 266 * [UIView scale], 112 * [UIView scale])];
        
        UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(containerView.frame) - 80 * [UIView scale]) / 2, 0, 80 * [UIView scale], 80 * [UIView scale])];
        errorImageView.image = [UIImage imageNamed:@"出题引导手势"];
        [containerView addSubview:errorImageView];
        
        YXCommonLabel *errorMsgLabel = [[YXCommonLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(errorImageView.frame) + 5 * [UIView scale], CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame) - CGRectGetMaxY(errorImageView.frame) - 5 * [UIView scale])];
        errorMsgLabel.font = [UIFont systemFontOfSize:14.f];
        errorMsgLabel.textAlignment = NSTextAlignmentCenter;
        errorMsgLabel.text = @"左右滑动，就可以切换试题哦 ^_^";
        [containerView addSubview:errorMsgLabel];
        
        YXAlertView *errorView = [YXAlertView alertWithMessage:nil style:YXAlertStyleAlert contentSize:CGSizeMake(306, 212)];
        [errorView addButtonWithTitle:@"知道了"];
        [errorView addContainerView:containerView];
        [errorView showInView:self.view];
        
        [YXQADataManager sharedInstance].qaHasEnteredBefore = YES;
    }
    NSMutableArray *vcArray = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (![vc isKindOfClass:[YXQAReportViewController_Pad class]]&&![vc isKindOfClass:[YXQAAnalysisViewController_Pad class]]) {
            [vcArray addObject:vc];
        }
    }
    self.navigationController.viewControllers = vcArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBG{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"登录背景"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UIImage *bookImage = [UIImage imageNamed:@"book_pad"];
    bookImage = [bookImage stretchableImageWithLeftCapWidth:200 topCapHeight:40];
    UIImageView *bookImageView = [[UIImageView alloc]initWithImage:bookImage];
    bookImageView.userInteractionEnabled = YES;
    [self.view addSubview:bookImageView];
    [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(69, 0, 23, 176));
    }];
    self.bookView = bookImageView;
    
    YXSideMenuCopyrightView_Pad *copyrightView = [[YXSideMenuCopyrightView_Pad alloc]init];
    [self.view addSubview:copyrightView];
    [copyrightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-42);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(0);
    }];
}

- (void)setupClock{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"计时器"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bookView.mas_top);
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
    [YXQATimer startWithInterval:1 triggerBlock:^(NSString *timeUsedString) {
        label.text = timeUsedString;
    }];
}

- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"提交icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"提交icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bookView.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(self.bookView.mas_top);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLeft
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(self.bookView.mas_top).mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(28+20, 28+20));
    }];
    [button addTarget:self action:@selector(naviLeftAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSlideForQA {
    self.slideView = [[YXSlideView alloc] init];
    self.slideView.datasource = self;
    self.slideView.delegate = self;
    [self.view addSubview:self.slideView];
    
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(180);
        make.right.mas_equalTo(-180-11);
        make.top.mas_equalTo(self.bookView.mas_top);
        make.bottom.mas_equalTo(-71);
    }];
    self.slideView.startIndex = 0;
#ifdef DEBUG
    [self addTestQidButton];
#endif
    
    self.progressView = [[YXQAProgressView_Pad alloc]init];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(180+40);
        make.right.mas_equalTo(-180-11-40);
        make.top.mas_equalTo(self.slideView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(31);
    }];
    WEAK_SELF
    self.progressView.preBlock = ^{
        STRONG_SELF
        NSInteger index = self.slideView.selectedIndex - 1;
        if (index < 0) {
            return;
        }
        [self.slideView goToIndex:index animated:YES];
    };
    self.progressView.nextBlock = ^{
        STRONG_SELF
        NSInteger index = self.slideView.selectedIndex + 1;
        if (index >= self.model.questions.count) {
            return;
        }
        [self.slideView goToIndex:index animated:YES];
    };
    [self.progressView updateWithIndex:0 total:self.model.questions.count];
}

- (void)setupMaskView{
    UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage yx_resizableImageNamed:@"遮罩"]];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.slideView.mas_left);
        make.right.mas_equalTo(self.slideView.mas_right);
        make.top.mas_equalTo(self.slideView.mas_top);
        make.bottom.mas_equalTo(self.slideView.mas_bottom).mas_offset(2);
    }];
}

- (void)setupPencilAndEraser{
    UIImageView *pencilView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"做题铅笔"]];
    [self.view addSubview:pencilView];
    [pencilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-60);
        make.bottom.mas_equalTo(-18);
        make.size.mas_equalTo(CGSizeMake(144, 144));
    }];
    UIImageView *eraserView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"做题橡皮"]];
    [self.view addSubview:eraserView];
    [eraserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(11);
        make.bottom.mas_equalTo(-202);
        make.size.mas_equalTo(CGSizeMake(90, 90));
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
        make.top.mas_equalTo(self.bookView.mas_top);
        make.right.mas_equalTo(-70);
    }];
}

- (void)buttonClick
{
    if (self.slideView.selectedIndex >= self.model.questions.count) {
        return;
    }
    NSString *answer = @"";
    QAQuestion *item = self.model.questions[self.slideView.selectedIndex];
    for (NSString *string in item.correctAnswers) {
        answer = [NSString stringWithFormat:@"%@ %@", answer, string];
    }
    [YXAlertView showAlertWithMessage:answer];
}

#pragma mark - Navi Action
- (void)naviRightAction{
    YXSlideViewItemViewBase *v = [self.slideView currentView];
    [v cancelLoading];
    if ([v isKindOfClass:[YXQAFillBlankView_Pad class]]) {
        YXQAFillBlankView_Pad *fillView = (YXQAFillBlankView_Pad *)v;
        [fillView hideKeyboard];
    }
    
    YXQASheetView_Pad *sheetView = [[YXQASheetView_Pad alloc]initWithFrame:self.view.bounds];
    sheetView.model = self.model;
    sheetView.delegate = self;
    [sheetView showInView:self.view];
    self.sheetView = sheetView;
}

- (void)naviLeftAction{
    YXSlideViewItemViewBase *v = [self.slideView currentView];
    [v cancelLoading];
    if ([v isKindOfClass:[YXQAFillBlankView_Pad class]]) {
        YXQAFillBlankView_Pad *fillView = (YXQAFillBlankView_Pad *)v;
        [fillView hideKeyboard];
    }
    
    BOOL unAnswered = TRUE;
    for (QAQuestion *item in [self.model allQuestions]) {
        if (item.answerState != YXAnswerStateNotAnswer) {
            if (item.templateType == YXQATemplateSubjective) {
                item.myAnswers = [NSMutableArray array];
                continue;
            }
            unAnswered = FALSE;
            //            break;
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
        [[YXQADataManager sharedInstance]savePaperToHistoryWithModel:self.model beginDate:self.beginDate];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    @weakify(self);
    YXAlertView *alert = [YXAlertView alertWithMessage:@"离开后，您可以在练习历史中找到记录并继续答题"];
    [alert addButtonWithTitle:@"取消" action:^{
        [v startLoading];
    }];
    [alert addButtonWithTitle:@"离开" action:^{
        @strongify(self);
        [[YXQADataManager sharedInstance]savePaperToHistoryWithModel:self.model beginDate:self.beginDate];
        [self.navigationController popViewControllerAnimated:YES];
        [YXQADataManager sharedInstance].hasDoExerciseToday = YES;
    }];
    [alert showInView:self.navigationController.view];
}

#pragma mark - Methods
- (void)submitPaper{
    if ([self.sheetView allHasAnswer]) {
        [self goReport];
        return;
    }
    @weakify(self);
    YXAlertView *alert = [YXAlertView alertWithMessage:@"还有未做完的题目，确定提交吗?"];
    [alert addCancelButton];
    [alert addButtonWithTitle:@"提交" action:^{
        @strongify(self);
        [self goReport];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)goReport{
    @weakify(self)
    [self startLoading];
    [[YXQADataManager sharedInstance]submitPaperWithModel:self.model beginDate:self.beginDate requestParams:self.requestParams completeBlock:^(NSError *error, QAPaperModel *reportModel) {
        @strongify(self)
        [self stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
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
                YXQASubmitSuccessAndBackView_Pad *backView = [[YXQASubmitSuccessAndBackView_Pad alloc]init];
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
            YXQASubmitSuccessView_Pad *successView = [[YXQASubmitSuccessView_Pad alloc]init];
            successView.pType = self.pType;
            WEAK_SELF
            successView.actionBlock = ^{
                STRONG_SELF
                YXQAReportViewController_Pad *vc = [[YXQAReportViewController_Pad alloc] init];
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

- (void)goToIndex:(NSInteger)index {
   
}

#pragma mark - slide tab datasource delegate

- (NSInteger)numberOfItemsInSlideView:(YXSlideView *)sender {
    return [self.model.questions count];
}

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQASingleChooseView_Pad *v = [[YXQASingleChooseView_Pad alloc]init];
        v.data = data;
        v.title = self.model.paperTitle;
        v.bShowTitleState = YES;
        v.delegate = self;
        return v;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAMultiChooseView_Pad *v = [[YXQAMultiChooseView_Pad alloc]init];
        v.data = data;
        v.title = self.model.paperTitle;
        v.bShowTitleState = YES;
        return v;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAYesNoView_Pad *v = [[YXQAYesNoView_Pad alloc]init];
        v.data = data;
        v.title = self.model.paperTitle;
        v.bShowTitleState = YES;
        v.delegate = self;
        return v;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAFillBlankView_Pad *v = [[YXQAFillBlankView_Pad alloc]init];
        v.data = data;
        v.title = self.model.paperTitle;
        v.bShowTitleState = YES;
        return v;
    }
    if (data.templateType == YXQATemplateSubjective) {
        YXQASubjectiveView_Pad *v = [[YXQASubjectiveView_Pad alloc]init];
        v.data = data;
        v.title = self.model.paperTitle;
        v.bShowTitleState = YES;
        v.delegate = self.addPhotoHandler;
        return v;
    }
//    if (data.itemType == YXQAItemMaterial) {
//        YXQAMaterialView_Pad *v = [[YXQAMaterialView_Pad alloc]init];
//        v.data = (YXQAComplexItem *)data;
//        v.title = self.model.title;
//        return v;
//    }
    
    return nil;
}

- (void)slideView:(YXSlideView *)aView slideFromIndex:(NSUInteger)from ToIndex:(NSUInteger)to{
    [self.progressView updateWithIndex:to total:self.model.questions.count];
}

- (void)slideView:(YXSlideView *)aView mostRightSlide:(UIPanGestureRecognizer *)aPanGesture{
    if (!self.sheetView.superview) {
        [self naviRightAction];
    }
}

#pragma mark - YXAutoGoNextDelegate
- (void)autoGoNextGoGoGo {
    if (self.slideView.selectedIndex == self.model.questions.count-1) {
        [self naviRightAction];
        return;
    }
    [self.slideView goToIndex:self.slideView.selectedIndex+1 animated:YES];
}

#pragma mark - YXQASheetViewDelegate
- (void)sheetViewDidSelectItem:(QAQuestion *)item{

}

- (void)sheetViewDidSubmit{
    [self submitPaper];
}

#pragma mark - YXQASubjectiveAddPhotoHandlerDelegate
- (UIViewController *)photoListVCWithViewModel:(YXAlbumViewModel *)viewModel title:(NSString *)title{
    UIViewController *viewController = [[YXPhotoListViewController_Pad alloc] initWithViewModel:viewModel];
    viewController.title = title;
    UINavigationController *navi = [[YXNavigationController_Pad alloc]initWithRootViewController:viewController];
    return navi;
}

- (MWPhotoBrowser *)photoBrowserWithTitle:(NSString *)title currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    YXPhotoBrowser_Pad * photoBrowser = [[YXPhotoBrowser_Pad alloc] initWithDelegate:self.addPhotoHandler];
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

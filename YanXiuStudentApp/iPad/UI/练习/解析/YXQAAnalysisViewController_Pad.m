//
//  YXQAAnalysisViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisViewController_Pad.h"
#import "YXSideMenuCopyrightView_Pad.h"
#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXQAAnalysisReportErrorViewController_Pad.h"
#import "YXPhotoBrowser_Pad.h"

@interface YXQAAnalysisViewController_Pad ()<YXQASubjectiveAddPhotoHandlerDelegate>
@property (nonatomic, strong) UIButton *favorButton;
@end

@implementation YXQAAnalysisViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBG];
    [self setupTitle];
    [self setupLeft];
    if (self.pType == YXPTypeIntelligenceExercise || self.pType == YXPTypeExerciseHistory){
        [self setupRight];
    }
    
    [self setupSlideForQA];
    [self setupMaskView];
    self.favorButton.hidden = YES;
    [self setupPencilAndEraser];
    
    self.addPhotoHandler = [[YXQASubjectiveAddPhotoHandler alloc]initWithViewController:self];
    self.addPhotoHandler.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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

- (void)setupTitle{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"解析标题背景"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bookView.mas_top);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(146, 40));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"006666"];
    label.text = @"题目解析";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [label yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(2);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-12);
    }];
}

- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"题目解析收藏icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"题目解析收藏icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bookView.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(self.bookView.mas_top);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
    self.favorButton = button;
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
    self.slideView.startIndex = self.firstLevel;
    
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

- (void)setupRightFavorStatus:(BOOL)isFavor{
    if (self.pType == YXPTypeIntelligenceExercise || self.pType == YXPTypeExerciseHistory) {
        if (isFavor) {
            [self.favorButton setImage:[UIImage imageNamed:@"题目解析收藏icon-成功"] forState:UIControlStateNormal];
            [self.favorButton setImage:[UIImage imageNamed:@"题目解析收藏icon-成功-按下"] forState:UIControlStateHighlighted];
        }else{
            [self.favorButton setImage:[UIImage imageNamed:@"题目解析收藏icon"] forState:UIControlStateNormal];
            [self.favorButton setImage:[UIImage imageNamed:@"题目解析收藏icon-按下"] forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - Navi Action
- (void)naviRightAction{
    QAQuestion *item = [self.model.questions objectAtIndex:self.slideView.selectedIndex];
    if (item.isFavorite) {
        [self startLoading];
        @weakify(self);
        [[YXQADataManager sharedInstance] deleteFavorWithItem:item completeBlock:^(NSError *error) {
            @strongify(self); if (!self) return;
            [self stopLoading];
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }else{
                [self setupRightFavorStatus:NO];
            }
        }];
    }else{
        [self startLoading];
        @weakify(self);
        [[YXQADataManager sharedInstance] addFavorWithItem:item requestParams:self.requestParams completeBlock:^(NSError *error) {
            @strongify(self); if (!self) return;
            [self stopLoading];
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }else{
                [self setupRightFavorStatus:YES];
            }
        }];
    }
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - slide tab datasource delegate
- (NSInteger)numberOfItemsInSlideView:(YXSlideView *)sender {
    return [self.model.questions count];
}

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    QAQuestion *data = [self.model.questions objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQAAnalysisSingleChooseView_Pad *bv = [[YXQAAnalysisSingleChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAAnalysisMultiChooseView_Pad *bv = [[YXQAAnalysisMultiChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAAnalysisYesNoView_Pad *bv = [[YXQAAnalysisYesNoView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAAnalysisFillBlankView_Pad *bv = [[YXQAAnalysisFillBlankView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateSubjective) {
        YXQAAnalysisSubjectiveView_Pad *bv = [[YXQAAnalysisSubjectiveView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        bv.delegate = self.addPhotoHandler;
        return bv;
    }
//    if (data.itemType == YXQAItemMaterial) {
//        YXQAAnalysisMaterialView_Pad *bv = [[YXQAAnalysisMaterialView_Pad alloc] init];
//        bv.data = (YXQAComplexItem *)data;
//        bv.title = self.model.title;
//        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
//        bv.pointClickDelegate = self;
//        bv.reportErrorDelegate = self;
//        bv.analysisDataDelegate = self.analysisDataDelegate;
//        if (index == self.firstLevel) {
//            if (self.secondLevel >= 0) {
//                bv.nextLevelStartIndex = self.secondLevel;
//                self.secondLevel = -1;
//            }
//        }
//        return bv;
//    }
    
    return nil;
}
- (void)slideView:(YXSlideView *)aView slideFromIndex:(NSUInteger)from ToIndex:(NSUInteger)to{
    if (to >= [self.model.questions count]) {
        return;
    }
    [self.progressView updateWithIndex:to total:self.model.questions.count];
    QAQuestion *item = self.model.questions[to];
    if (item.isFavorite) {
        [self setupRightFavorStatus:YES];
    }else{
        [self setupRightFavorStatus:NO];
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
    @weakify(self);
    [[YXExerciseListManager sharedInstance] requestQAWithParams:params completion:^(YXIntelligenceQuestion *question, NSError *error) {
        @strongify(self);
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (question && !error) {
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc] init];
            vc.requestParams = params;
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.pType = self.pType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark YXQAAnalysisReportErrorDelegate

- (void)reportAnalysisErrorWithID:(NSString *)qid
{
    YXQAAnalysisReportErrorViewController_Pad *vc = [[YXQAAnalysisReportErrorViewController_Pad alloc]init];
    vc.qid = qid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)canReportError{
//    return self.pType != YXPTypeGroupHomework;
    return YES;
}

#pragma mark - YXQASubjectiveAddPhotoHandlerDelegate
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

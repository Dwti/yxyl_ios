//
//  YXSmartExerciseViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/7/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXSmartExerciseViewController.h"
#import "YXCommonErrorView.h"
#import "AppDelegate.h"

#import "YXChooseEditionViewController.h"
#import "ExerciseKnowledgeChooseViewController.h"

#import "YXUpdateUserInfoRequest.h"
#import "YXRankViewController.h"
#import "YXRankRequest.h"
#import "ExerciseHistorySubjectViewController.h"

#import "YXExerciseChooseEdition_SubjectView.h"
#import "YXExerciseChooseEdition_SubjectEditionListedView.h"
#import "YXPaperMainViewController.h"
#import "PaperListViewController.h"

@interface YXSmartExerciseViewController () <YXExerciseChooseEdition_SubjectViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) GetSubjectRequestItem *item;
@property (nonatomic, assign) BOOL isViewAppear;
@property (nonatomic, strong) YXRankRequest *rankRequest;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGPoint formerScrollOffset;
@property (nonatomic, strong) YXExerciseChooseEdition_SubjectEditionListedView *chooseEditionView;

@end

@implementation YXSmartExerciseViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRightNaviButtons];
#ifdef DEBUG
    [self setupLeftNavi];
#endif
    [self registerNotifications];
    [self _setupUI];
    [self requestSubjects];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestSubjects];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isViewAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isViewAppear = NO;
}

- (void)setupLeftNavi{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"出题" style:UIBarButtonItemStylePlain target:self action:@selector(goToPaper)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"新出题" style:UIBarButtonItemStylePlain target:self action:@selector(goToPaperList)];
    self.navigationItem.leftBarButtonItems = @[item,item2];
}

- (void)goToPaper{
    YXPaperMainViewController *vc = [[YXPaperMainViewController alloc]init];
    YXNavigationController *navi = [[YXNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)goToPaperList{
    PaperListViewController *vc = [[PaperListViewController alloc]init];
    YXNavigationController *navi = [[YXNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)setupRightNaviButtons
{
    UIButton *rankButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [rankButton setImage:[UIImage imageNamed:@"排行榜按钮"] forState:UIControlStateNormal];
    [rankButton addTarget:self action:@selector(goToRank) forControlEvents:UIControlEventTouchUpInside];
    UIButton *historyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [historyButton setImage:[UIImage imageNamed:@"首页练习历史"] forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(goToHistory) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rankItem = [[UIBarButtonItem alloc]initWithCustomView:rankButton];
    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc]initWithCustomView:historyButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,historyItem,rankItem];
}

- (void)goToHistory
{
    ExerciseHistorySubjectViewController *vc = [[ExerciseHistorySubjectViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToRank
{
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
    [self.rankRequest stopRequest];
    self.rankRequest = [[YXRankRequest alloc]init];
    [self yx_startLoading];
    @weakify(self);
    [self.rankRequest startRequestWithRetClass:[YXRankRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = YES;
        }
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXRankRequestItem *item = (YXRankRequestItem *)retItem;
        if (item.data.count == 0) {
            [self yx_showToast:@"暂无数据"];
            return;
        }
        YXRankModel *model = [YXRankModel rankModelFromRankRequestItem:item];
        YXRankViewController *vc = [[YXRankViewController alloc]init];
        vc.rankModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)requestSubjects
{
    [self doHideAfterChangeStageOrReLogin];
    
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    [self _reloadUI];
    
    [self yx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance] requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = YES;
        }
        self.errorView.hidden = YES;
        if (error) {
            if (!self.item.subjects) {
                self.errorView.hidden = NO;
            }
            if (self.isViewAppear) {
                [self yx_showToast:error.localizedDescription];
            }
        } else {
            self.item = retItem;
            [self _reloadUI];
        }
    }];
}

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(saveEditionInfoSuccess)
                   name:kSubjectSaveEditionInfoSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(updateUserInfoSuccess:)
                   name:YXUpdateUserInfoSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(applicationWillEnterForeground)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserInfoSuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:YXUpdateUserInfoTypeKey] integerValue] == YXUpdateUserInfoTypeStage) {
        [self requestSubjects];
    }
}

- (void)applicationWillEnterForeground
{
    //[self requestSubjects];
}

- (void)saveEditionInfoSuccess
{
    self.item = [[ExerciseSubjectManager sharedInstance]currentSubjectItem];
    [self _reloadUI];
}

- (void)goSubjectDetail:(GetSubjectRequestItem_subject *)subject {
    [self goSubjectDetail:subject isBackToRootViewController:NO];
}

- (void)goSubjectDetail:(GetSubjectRequestItem_subject *)subject isBackToRootViewController:(BOOL)isBackToRootViewController
{
    ExerciseKnowledgeChooseViewController *vc = [[ExerciseKnowledgeChooseViewController alloc] init];
    vc.subject = subject;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 2.0

- (void)_setupUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = [UIImage imageNamed:@"练习-背景-拷贝"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.maskView.frame = self.scrollView.frame;
    [self.view insertSubview:self.maskView aboveSubview:self.scrollView];
    self.maskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.maskView addGestureRecognizer:tap];
}

- (void)_reloadUI {
    for (UIView *v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    NSInteger itemCount = [self.item.subjects count];
    NSInteger rowCount = (itemCount + 1) / 2;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (50 + 125) * rowCount + 50);
    
    CGFloat hGap = (self.scrollView.frame.size.width - 2 * 145 - 15) * 0.5;
    for (NSInteger i = 0; i < itemCount; i++) {
        YXExerciseChooseEdition_SubjectView *v = [[YXExerciseChooseEdition_SubjectView alloc] init];
        v.tag = i;
        v.delegate = self;
        CGRect oFrame = v.frame;
        NSInteger row = i / 2;
        NSInteger column = i % 2;
        v.frame = CGRectMake(hGap + column * (145 + 15), 50 + row * (50 + 125), oFrame.size.width, oFrame.size.height);
        [self.scrollView addSubview:v];
        
        GetSubjectRequestItem_subject *data = self.item.subjects[i];
        [v updateWithData:data];
    }
}

- (void)maskTap:(UIGestureRecognizer *)tap {
    [self.chooseEditionView doHide];
}

#pragma mark - YXExerciseChooseEdition_SubjectViewDelegate
- (void)subjectViewSubjectTapped:(YXExerciseChooseEdition_SubjectView *)view {
    int index = (int)view.tag;
    GetSubjectRequestItem_subject *subject = self.item.subjects[index];

    if (isEmpty(subject.edition)) {
        [self subjectViewChooseEditionTapped:view];
    } else {
        [self goSubjectDetail:subject];
    }
}

- (void)subjectViewChooseEditionTapped:(YXExerciseChooseEdition_SubjectView *)view {
    int index = (int)view.tag;
    GetSubjectRequestItem_subject *subject = self.item.subjects[index];
//    if (subject.data.editionId.length){
//        return;
//    }
    @weakify(self);
    [self yx_startLoading];
    [[ExerciseSubjectManager sharedInstance]requestEditionsWithSubjectID:subject.subjectID completeBlock:^(GetEditionRequestItem *retItem, NSError *error) {
        @strongify(self); if (!self) return;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        
        int row = index / 2;
        self.formerScrollOffset = self.scrollView.contentOffset;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = CGPointMake(0, row * (50 + 125));
                         } completion:^(BOOL finished) {
                             self.maskView.hidden = NO;
                             
                             CGFloat hGap = (self.scrollView.frame.size.width - 2 * 145 - 15) * 0.5;
                             CGRect oFrame = CGRectMake(0, 0, 145, 125);
                             int row = 0;
                             int column = index % 2;
                             CGRect rect = CGRectMake(hGap + column * (145 + 15), 50 + row * (50 + 125), oFrame.size.width, 86);
                             YXExerciseChooseEdition_SubjectEditionListedView *v = [[YXExerciseChooseEdition_SubjectEditionListedView alloc] initWithFrame:rect];
                             [self.maskView addSubview:v];
                             v.subject = subject;
                             v.editionItem = retItem;
                             
                             v.choosenBlock = ^void(GetEditionRequestItem_edition *edition) {
                                 for (UIView *v in self.maskView.subviews) {
                                     [v removeFromSuperview];
                                 }
                                 
                                 [UIView animateWithDuration:0.3
                                                  animations:^{
                                                      self.scrollView.contentOffset = self.formerScrollOffset;
                                                  } completion:^(BOOL finished) {
                                                      self.maskView.hidden = YES;
                                                      if (isEmpty(edition)) {
                                                          return;
                                                      }
                                                      
                                                      if ([edition.editionID isEqualToString:subject.edition.editionId]) {
                                                          [self goSubjectDetail:subject];
                                                          return;
                                                      }
                                                      
                                                      
                                                      if (edition) {
                                                          [self saveEdition:edition forSubject:subject];
                                                          return;
                                                      }
                                                  }];
                                 
                             };
                             
                             self.chooseEditionView = v;
                         }];
    }];
}

- (void)saveEdition:(GetEditionRequestItem_edition *)edition forSubject:(GetSubjectRequestItem_subject *)subject {
    WEAK_SELF
    [self yx_startLoading];
    [[ExerciseSubjectManager sharedInstance]saveEditionWithSubjectID:subject.subjectID editionID:edition.editionID completeBlock:^(GetSubjectRequestItem_subject *retItem, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        } else {
            [self goSubjectDetail:retItem];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.maskView) {
        return YES;
    }

    return NO;
}

#pragma mark - choose edition

- (void)doHideAfterChangeStageOrReLogin {
    @weakify(self);
    self.chooseEditionView.choosenBlock = ^void(GetEditionRequestItem_edition *edition) {
        @strongify(self); if (!self) return;
        for (UIView *v in self.maskView.subviews) {
            [v removeFromSuperview];
        }
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.contentOffset = self.formerScrollOffset;
                         } completion:^(BOOL finished) {
                             self.maskView.hidden = YES;
                             if (isEmpty(edition)) {
                                 return;
                             }
                         }];
        
    };
    
    
    [self.chooseEditionView doHide];

}

@end

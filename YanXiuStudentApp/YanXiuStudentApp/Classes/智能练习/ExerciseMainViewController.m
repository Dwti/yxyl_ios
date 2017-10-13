//
//  ExerciseMainViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExerciseMainViewController.h"
#import "YXPaperMainViewController.h"
#import "PaperListViewController.h"
#import "YXCommonErrorView.h"
#import "GetSubjectRequest.h"
#import "ExerciseMainSubjectCell.h"
#import "TextbookVersionView.h"
#import "ChooseEditionViewController.h"
#import "ExerciseKnowledgeChooseViewController.h"
#import "BCResourceViewController.h"

@interface ExerciseMainViewController ()
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, assign) BOOL isViewAppear;
@property (nonatomic, strong) TextbookVersionView *textbookVersionView;
@property (nonatomic, strong) GetSubjectRequestItem *item;

@end


@implementation ExerciseMainViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
#ifdef DEBUG
    [self setupLeftNavi];
#endif
    [self registerNotifications];
    [self setupUI];
    [self requestSubjects];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
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
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestSubjects
{
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    self.textbookVersionView.item = self.item;
    
    [self.view nyx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance] requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            if (!self.item.subjects) {
                [self.view addSubview:self.errorView];
                [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];
            }
            if (self.isViewAppear) {
                [self.view nyx_showToast:error.localizedDescription];
            }
        } else {
            [self.errorView removeFromSuperview];
            self.item = retItem;
            self.textbookVersionView.item = self.item;
        }
    }];
}

- (void)saveEditionInfoSuccess
{
    self.item = [[ExerciseSubjectManager sharedInstance]currentSubjectItem];
    self.textbookVersionView.item = self.item;
}

- (void)updateUserInfoSuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:YXUpdateUserInfoTypeKey] integerValue] == YXUpdateUserInfoTypeStage) {
        [self requestSubjects];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.textbookVersionView = [[TextbookVersionView alloc]init];
    WEAK_SELF
    [self.textbookVersionView setChooseVersionActionBlock:^(GetSubjectRequestItem_subject *subject, BOOL hasChoosedEdition) {
        STRONG_SELF
        if ([[YXUserManager sharedManager].userModel.stageid isEqualToString:@"1202"] && [subject.name isEqualToString:@"BC资源"]) {
            BCResourceViewController *vc = [[BCResourceViewController alloc]init];
            vc.subject = subject;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (hasChoosedEdition) {
            [self goToExerciseListWithSubject:subject];
        }else {
            [self requestEditionsWithSubject:subject];
        }
    }];
    [self.view addSubview:self.textbookVersionView];
    [self.textbookVersionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)goToExerciseListWithSubject:(GetSubjectRequestItem_subject *)subject {
    ExerciseKnowledgeChooseViewController *vc = [[ExerciseKnowledgeChooseViewController alloc] init];
    vc.subject = subject;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestEditionsWithSubject:(GetSubjectRequestItem_subject *)subject {
    WEAK_SELF
    [self.view nyx_startLoading];
    [[ExerciseSubjectManager sharedInstance]requestEditionsWithSubjectID:subject.subjectID completeBlock:^(GetEditionRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (retItem && retItem.editions.count == 0) {
            if (retItem.status.desc) {
                [self.view nyx_showToast:retItem.status.desc];
            }
            return;
        }
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        ChooseEditionViewController *vc = [[ChooseEditionViewController alloc]init];
        vc.subject = subject;
        vc.type = ChooseEditionFromType_ExerciseMain;
        vc.item = retItem;
        WEAK_SELF
        [vc setChooseEditionSuccessBlock:^(GetSubjectRequestItem_subject *subject) {
            STRONG_SELF
            [self goToExerciseListWithSubject:subject];
        }];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

@end

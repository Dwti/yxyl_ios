//
//  TextBookVersionViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TextBookVersionViewController.h"
#import "YXCommonErrorView.h"
#import "GetSubjectRequest.h"
#import "ExerciseMainSubjectCell.h"
#import "TextbookVersionView.h"
#import "ChooseEditionViewController.h"

@interface TextBookVersionViewController ()
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) TextbookVersionView *textbookVersionView;
@property (nonatomic, strong) GetSubjectRequestItem *item;
@end

@implementation TextBookVersionViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"教材版本";
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

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(saveEditionInfoSuccess)
                   name:kSubjectSaveEditionInfoSuccessNotification
                 object:nil];
}

- (void)saveEditionInfoSuccess
{
    self.item = [[ExerciseSubjectManager sharedInstance]currentSubjectItem];
    self.textbookVersionView.item = self.item;
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestSubjects
{
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    if (self.item.subjects) {
        self.textbookVersionView.item = self.item;
        return;
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance] requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.item = retItem;
        if (self.item) {
            self.textbookVersionView.item = self.item;
        } else {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.textbookVersionView = [[TextbookVersionView alloc]init];
    WEAK_SELF
    [self.textbookVersionView setChooseVersionActionBlock:^(GetSubjectRequestItem_subject *subject, BOOL hasChoosedEdition) {
        STRONG_SELF
            DDLogDebug(@"%@跳转到版本选择",subject);
            ChooseEditionViewController *vc = [[ChooseEditionViewController alloc]init];
            vc.subject = subject;
            vc.type = ChooseEditionFromType_PersonalCenter;
            [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:self.textbookVersionView];
    [self.textbookVersionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


@end

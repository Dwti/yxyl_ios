//
//  YXExerciseChooseEditionViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/26/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseEditionViewController_Pad.h"
#import "YXExerciseChooseEdition_ContainerView.h"
#import "YXGetSubjectRequest.h"
#import "YXGetEditionsRequest.h"
#import "YXExerciseQuizViewController.h"
#import "YXCommonErrorView.h"

#import "YXUpdateUserInfoRequest.h"
#import "YXExerciseQuizViewController_Pad.h"

@interface YXExerciseChooseEditionViewController_Pad () <YXExerciseChooseEdition_ContainerViewDelegate>
@property (nonatomic, strong) YXExerciseChooseEdition_ContainerView *containerView;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@property (nonatomic, strong) YXNodeElementListItem *dataItem;  // data为subject的Array
@end

@implementation YXExerciseChooseEditionViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bgImage = [UIImage imageNamed:@"练习背景"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.containerView = [[YXExerciseChooseEdition_ContainerView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.columnCount = 4;
    self.containerView.hGap = 42;
    self.containerView.vGap = 25 + 15 /* icon高度 */;
    self.containerView.delegate = self;
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self reloadSubjects];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        self.errorView.hidden = YES;
        [self reloadSubjects];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUpdateUserInfoSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self reloadSubjects];
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXSubjectSaveEditionInfoSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self reloadSubjects];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadSubjects {
    [self startLoading];
    @weakify(self);
    [[YXGetSubjectManager sharedManager] startRequestWithCompleleBlock:^(YXNodeElementListItem *item, NSError *error, BOOL isCache) {
        @strongify(self); if (!self) return;
        [self stopLoading];
        if (isCache) {
            self.dataItem = item;
            [self.containerView reloadWithSubjects:item.data];
            return;
        }
        
        if (error) {
            self.errorView.hidden = NO;
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            return;
        }
        
        self.dataItem = item;
        [self.containerView reloadWithSubjects:item.data];
    } shouldReturnCache:YES];
}

#pragma mark -
- (void)chooseEditionForSubject:(YXNodeElement *)subject {
    [self startLoading];
    @weakify(self);
    [[YXGetEditionsManager sharedManager] startRequestWithSubjectId:subject.eid
                                                      compleleBlock:^(YXNodeElementListItem *item, NSError *error, BOOL isCache) {
                                                          @strongify(self); if (!self) return;
                                                          [self stopLoading];
                                                          if (error) {
                                                              [self yx_showToast:error.localizedDescription];
                                                              return;
                                                          }
                                                          
                                                          subject.children = item.data;
                                                          [self.containerView showEditionsToChooseForSubject:subject];
                                                      } shouldReturnCache:NO];
}

- (void)gotoChooseChapterKnpForSubject:(YXNodeElement *)subject {
    YXExerciseQuizViewController_Pad *vc = [[YXExerciseQuizViewController_Pad alloc] init];
    vc.subject = subject;
    vc.leftRightGapForTreeView = 65;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)edition:(YXNodeElement *)edition ChoosedForSubject:(YXNodeElement *)subject {
    [self startLoading];
    [[YXGetSubjectManager sharedManager] saveChoosedEdition:edition forSubject:subject completeBlock:^(NSError *error) {
        [self stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self.containerView reloadWithSubjects:self.dataItem.data];
        [self gotoChooseChapterKnpForSubject:subject];
    }];
}

@end

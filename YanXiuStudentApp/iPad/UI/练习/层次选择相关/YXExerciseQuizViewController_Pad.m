//
//  YXExerciseQuizViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXExerciseQuizViewController_Pad.h"
#import "YXAnswerQuestionViewController.h"
#import "YXExerciseQuizCell.h"
#import "YXDiagnosticsTipsView.h"
#import "YXAppStartupManager.h"
#import "YXGetEditionsRequest.h"
#import "YXListKnpStateRequest.h"
#import "YXDiagnoseModel.h"
#import "YXDiagnoseViewController.h"
#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXSplitViewController.h"
#import "YXDiagnosisViewController_Pad.h"
#import "YXSplitViewController.h"

@interface YXExerciseQuizViewController_Pad ()

@property (nonatomic, strong) YXListKnpStateRequest *knpStateRequest;

@end

@implementation YXExerciseQuizViewController_Pad

- (void)yx_leftBackButtonPressed:(id)sender
{
    if (self.isBackToRootViewController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [super yx_leftBackButtonPressed:sender];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"练习背景"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

// 跳转诊断界面
- (void)yx_rightButtonPressed:(id)sender
{
<<<<<<< f69f0374f9673cd67d978128ed7725de876bebf1:YanXiuStudentApp/iPad/UI/练习/层次选择相关/YXExerciseQuizViewController_Pad.m
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
    [self.knpStateRequest stopRequest];
    self.knpStateRequest = [[YXListKnpStateRequest alloc]init];
    self.knpStateRequest.subjectId = self.subject.eid;
    self.knpStateRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self yx_startLoading];
    @weakify(self);
    [self.knpStateRequest startRequestWithRetClass:[YXListKnpStateRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (!self) {
            return;
        }
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = YES;
        }
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXDiagnoseModel *model = [YXDiagnoseModel modelFromListKnpStateRequestItem:retItem];
        YXDiagnosisViewController_Pad *vc = [[YXDiagnosisViewController_Pad alloc]init];
        vc.model = model;
        vc.subject = self.subject;
        [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
    }];
=======
//    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
//        item.enabled = NO;
//    }
//    [self.knpStateRequest stopRequest];
//    self.knpStateRequest = [[YXListKnpStateRequest alloc]init];
//    self.knpStateRequest.subjectId = self.subject.subjectID;
//    self.knpStateRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
//    [self yx_startLoading];
//    @weakify(self);
//    [self.knpStateRequest startRequestWithRetClass:[YXListKnpStateRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
//        @strongify(self);
//        if (!self) {
//            return;
//        }
//        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
//            item.enabled = YES;
//        }
//        [self yx_stopLoading];
//        if (error) {
//            [self yx_showToast:error.localizedDescription];
//            return;
//        }
//        YXDiagnoseModel *model = [YXDiagnoseModel modelFromListKnpStateRequestItem:retItem];
//        YXDiagnoseViewController *vc = [[YXDiagnoseViewController alloc]init];
//        vc.model = model;
//        vc.subject = self.subject;
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
>>>>>>> 学科版本重构:YanXiuStudentApp/YanXiuStudentApp/v1.2/练习/YXExerciseQuizViewController.m
}

- (YXExerciseListParams *)listParams
{
    YXExerciseListParams *params = [super listParams];
    params.type = YXExerciseListTypeQuiz;
    return params;
}

#pragma mark - YXExerciseListViewDelegate

- (Class)cellClass
{
    return [YXExerciseQuizCell class];
}

- (void)requestVolumeListWithCompletion:(YXVolumeListRespBlock)completion
{
//    [YXGetEditionsManager requestVolumeWithSubjectId:self.subject.eid editionId:self.subject.data.editionId  compeletion:^(NSArray *volumeItem, YXNodeElement *currentVolume, BOOL hasKnp, NSError *error) {
//        if (completion) {
//            completion(volumeItem, currentVolume, hasKnp, error);
//        }
//    }];
}

// 智能练习缓存选中的册
- (void)saveCacheWithVolume:(YXNodeElement *)volume
{
//    [[YXGetEditionsManager sharedManager] setSelectedVolume:volume
//                                                  subjectId:self.subject.eid
//                                          selectedEditionId:self.subject.data.editionId];
}

- (void)requestExerciseListWithCompletion:(YXExerciseListRespBlock)completion
{
    [[YXExerciseListManager sharedInstance] requestListWithParams:[self listParams] completion:^(YXExerciseListModel *model, BOOL isCache, NSError *error) {
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)showQuestionWithChapter:(YXNodeElement *)chapter
                        section:(YXNodeElement *)section
                           cell:(YXNodeElement *)cell
{
    YXExerciseListParams *listParams = [self listParams];
    YXQARequestParams *params = [[YXQARequestParams alloc] init];
    params.stageId = listParams.stageId;
    params.subjectId = listParams.subjectId;
    params.editionId = listParams.editionId;
    params.volumeId = listParams.volumeId;
    params.type = listParams.type;
    params.segment = listParams.segment;
    params.chapterId = chapter.eid;
    params.sectionId = section.eid ?:@"0";
    params.cellId = cell.eid ?:@"0";
    params.questNum = @"10";
    
    // TBTest : cailei
    if (listParams.segment == YXExerciseListSegmentTestItem) {
        params.fromType = @"2";
    }
    
    @weakify(self);
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    [[YXExerciseListManager sharedInstance] requestQAWithParams:params completion:^(YXIntelligenceQuestion *question, NSError *error) {
        @strongify(self);
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (question) {
//            YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
//            vc.requestParams = params;
//            vc.question = question;
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc]init];
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.requestParams = params;
            [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)showQuestionWithKnpL0:(YXNodeElement *)knpL0
                        knpL1:(YXNodeElement *)knpL1
                        knpL2:(YXNodeElement *)knpL2
{
    [self showQuestionWithChapter:knpL0
                          section:knpL1
                             cell:knpL2];
}

- (void)showDiagnosticsTips
{
    UIViewController *viewController = [YXAppStartupManager sharedInstance].window.rootViewController;
    [YXDiagnosticsTipsView showWithSuperView:viewController.view];
}

- (void)zhenDuanAction
{
    [self yx_rightButtonPressed:nil];
}

@end

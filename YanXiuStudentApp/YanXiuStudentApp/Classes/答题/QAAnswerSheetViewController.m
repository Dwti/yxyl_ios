//
//  QAAnswerSheetViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerSheetViewController.h"
#import "QAAnswerSheetView.h"
#import "QAAnswerSheetCell.h"
#import "QAImageUploadProgressView.h"
#import "YXRecordManager.h"
#import "YXProblemItem.h"

@interface QAAnswerSheetViewController ()
@property (nonatomic, strong) QAAnswerSheetView *sheetView;
@property (nonatomic, strong) QAImageUploadProgressView *uploadImageView;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, copy) SelectedActionBlock buttonActionBlock;
@end

@implementation QAAnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    self.title = self.model.paperTitle;
    [self setupObserver];
    self.beginDate = [NSDate date];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.sheetView = [[QAAnswerSheetView alloc]init];
    self.sheetView.model = self.model;
    WEAK_SELF
    [self.sheetView setSubmitActionBlock:^{
        STRONG_SELF
        if (self.allHasWrote) {
            [self submitAnswers];
            return;
        }
        WEAK_SELF
        EEAlertView *alert = [[EEAlertView alloc] init];
        alert.title = @"还有未做完的题目，确定提交吗?";
        [alert addButtonWithTitle:@"取消" action:^{
            STRONG_SELF
            
        }];
        [alert addButtonWithTitle:@"提交" action:^{
            STRONG_SELF
            [self submitAnswers];
        }];
        [alert showInView:self.navigationController.view];
    }];
    [self.view addSubview:self.sheetView];
    [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQASelectedQuestionNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        QAQuestion *item = dic[kQASelectedQuestionKey];
        [self.navigationController popViewControllerAnimated:YES];
        BLOCK_EXEC(self.buttonActionBlock,item);
    }];
}


- (void)submitAnswers {
    DDLogDebug(@"提交答案");
//    self.uploadImageView = [[QAImageUploadProgressView alloc]init];
//    [self.view addSubview:self.uploadImageView];
//    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
//    [self.uploadImageView updateWithUploadedCount:13 totalCount:30];
    [self goReport];
}

- (void)setSelectedActionBlock:(SelectedActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)goReport {
    if (![self isNetworkReachable]) {
        [self yx_showToast:@"网络异常，请检查网络后重试"];
        return;
    }
    [self setupUploadImageView];
    WEAK_SELF
    [[YXQADataManager sharedInstance]submitPaperWithModel:self.model beginDate:self.beginDate requestParams:self.requestParams completeBlock:^(NSError *error, QAPaperModel *reportModel) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self.uploadImageView removeFromSuperview];
            [self handleSubmitFailure:error];
        }else{
            
            YXProblemItem *item = [YXProblemItem new];
//            item.paperType      = @(self.pType == YXPTypeGroupHomework? 1: 0);
            item.editionID      = self.requestParams.editionId;
            item.subjectID      = self.requestParams.subjectId;
//            item.quesNum        = self.sheetView.wrote.length? self.sheetView.wrote: @"0";
            item.gradeID        = self.model.gradeID;
            item.type           = YXRecordSubmitWorkType;
            NSMutableArray *questions = [NSMutableArray new];
            for (QAQuestion *question in self.model.questions) {
                [questions addObject:question.questionID];
            }
            item.questionID = questions;
            [YXRecordManager addRecord:item];
            
//            if (self.pType == YXPTypeGroupHomework && !reportModel.canShowHomeworkAnalysis) {
//                YXQASubmitSuccessAndBackView_Phone *backView = [[YXQASubmitSuccessAndBackView_Phone alloc]init];
//                backView.endDate = reportModel.homeworkEndDate;
//                WEAK_SELF
//                backView.actionBlock = ^{
//                    STRONG_SELF
//                    [self.navigationController popViewControllerAnimated:YES];
//                };
//                [self.view addSubview:backView];
//                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.edges.mas_equalTo(0);
//                }];
//                return;
//            }
//            if (self.pType != YXPTypeGroupHomework) {
//                [YXQADataManager sharedInstance].hasDoExerciseToday = YES;
//            }
//            YXQASubmitSuccessView_Phone *successView = [[YXQASubmitSuccessView_Phone alloc]init];
//            successView.pType = self.pType;
//            WEAK_SELF
//            successView.actionBlock = ^{
//                STRONG_SELF
//                YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
//                vc.model = reportModel;
//                vc.requestParams = self.requestParams;
//                vc.pType = self.pType;
//                vc.canDoExerciseAgain = self.pType == YXPTypeIntelligenceExercise? YES:NO;
//                [self.navigationController pushViewController:vc animated:YES];
//            };
//            [self.view addSubview:successView];
//            [successView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(0);
//            }];
        }
    }];
}

- (void)setupUploadImageView {
    self.uploadImageView = [[QAImageUploadProgressView alloc]init];
    [self.view addSubview:self.uploadImageView];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [[YXQADataManager sharedInstance]setUploadImageBlock:^(NSInteger index, NSInteger total) {
        STRONG_SELF
        if (index == total) {
            [self.uploadImageView removeFromSuperview];
            [self yx_startLoading];
            return;
        }
        [self.uploadImageView updateWithUploadedCount:index totalCount:total + 1];
    }];
}

- (void)handleSubmitFailure:(NSError *)error {
    if ([self isNetworkReachable]) {
        [self yx_showToast:error.localizedDescription];
        return;
    }
    WEAK_SELF
    EEAlertView *alert = [[EEAlertView alloc] init];
    alert.title = @"作业上传失败，请检查网络后重试";
    [alert addButtonWithTitle:@"取消" action:^{
        STRONG_SELF
    }];
    [alert addButtonWithTitle:@"再试一次" action:^{
        STRONG_SELF
        [self goReport];
    }];
    [alert showInView:self.view];
}

@end

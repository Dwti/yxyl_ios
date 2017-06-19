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
#import "QAAlertView.h"
#import "QAReportViewController.h"

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
        if (self.answeredQuestionCount == self.totalQuestionCount) {
            [self submitPaper];
            return;
        }
        WEAK_SELF
        QAAlertView *alert = [[QAAlertView alloc] init];
        alert.title = @"还有未答完的题目";
        alert.describe = @"确定要提交吗";
        alert.imageName = @"";
        [alert addButtonWithTitle:@"取消" style:QAAlertActionStyle_Cancel action:^{
            STRONG_SELF
        }];
        [alert addButtonWithTitle:@"提交" style:QAAlertActionStyle_Default action:^{
            STRONG_SELF
             [self submitPaper];
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

- (void)submitPaper {
    if (![self isNetworkReachable]) {
        [self yx_showToast:@"网络异常，请检查网络后重试"];
        return;
    }
    [self setupUploadImageView];
    WEAK_SELF
    [[YXQADataManager sharedInstance]submitPaperWithModel:self.model beginDate:self.beginDate requestParams:self.requestParams completeBlock:^(NSError *error, QAPaperModel *reportModel) {
        STRONG_SELF
        [self.uploadImageView removeFromSuperview];
        [self.view nyx_stopLoading];
        //测试用
//        QAReportViewController *vc = [[QAReportViewController alloc]init];
//        vc.model = self.model;
//        [self.navigationController pushViewController:vc animated:YES];
        if (error) {
            [self handleSubmitFailure:error];
        }else{
            
            YXProblemItem *item = [YXProblemItem new];
            item.paperType      = @(self.pType == YXPTypeGroupHomework? 1: 0);
            item.editionID      = self.requestParams.editionId;
            item.subjectID      = self.requestParams.subjectId;
            item.quesNum        = [NSString stringWithFormat:@"%@",@(self.answeredQuestionCount)];
            item.gradeID        = self.model.gradeID;
            item.type           = YXRecordSubmitWorkType;
            NSMutableArray *questions = [NSMutableArray new];
            for (QAQuestion *question in self.model.questions) {
                [questions addObject:question.questionID];
            }
            item.questionID = questions;
            [YXRecordManager addRecord:item];
            
            // 提交成功后清除本地保存的答案
            [self.model.allQuestions enumerateObjectsUsingBlock:^(QAQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj clearAnswer];
            }];
            
            if (self.pType == YXPTypeGroupHomework && !reportModel.canShowHomeworkAnalysis) {
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
                NSDateFormatter *formater = [[NSDateFormatter alloc]init];
                [formater setDateFormat:@"yyyy/MM/dd HH:mm"];
                NSString *dateString = [formater stringFromDate:reportModel.homeworkEndDate];
                NSString *totalString = [NSString stringWithFormat:@"截止时间为：%@",dateString];
                [self.view nyx_showToast:[NSString stringWithFormat:@"需要等到截止期%@之后才能显示报告",totalString]];
                return;
            }
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
            
            QAReportViewController *vc = [[QAReportViewController alloc]init];
            vc.model = reportModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)setupUploadImageView {
    self.uploadImageView = [[QAImageUploadProgressView alloc]init];
    [self.navigationController.view addSubview:self.uploadImageView];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [[YXQADataManager sharedInstance]setUploadImageBlock:^(NSInteger index, NSInteger total) {
        STRONG_SELF
        if (index == total) {
            if (total == 0) {
                [self.uploadImageView removeFromSuperview];
                [self.view nyx_startLoading];
            }
            return;
        }
        [self.uploadImageView updateWithUploadedCount:index totalCount:total];
    }];
}

- (void)handleSubmitFailure:(NSError *)error {
    if ([self isNetworkReachable]) {
        [self.view nyx_showToast:error.localizedDescription];
        return;
    }
    WEAK_SELF
    QAAlertView *alert = [[QAAlertView alloc] init];
    alert.title = @"作业上传失败";
    alert.describe = @"请检查网络是否异常后重试";
    alert.imageName = @"";
    [alert addButtonWithTitle:@"取消" style:QAAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alert addButtonWithTitle:@"再试一次" style:QAAlertActionStyle_Default action:^{
        STRONG_SELF
        [self submitPaper];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)setSelectedActionBlock:(SelectedActionBlock)block {
    self.buttonActionBlock = block;
}
@end

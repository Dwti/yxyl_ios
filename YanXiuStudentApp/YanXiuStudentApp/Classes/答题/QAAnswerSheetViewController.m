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
#import "SimpleAlertView.h"
#import "QAReportViewController.h"
#import "QAAnswerQuestionViewController.h"

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
        SimpleAlertView *alert = [[SimpleAlertView alloc] init];
        alert.title = @"还有未答完的题目";
        alert.describe = @"确定要提交吗";
        alert.image = [UIImage imageNamed:@"提交成功图标"];
        [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
            STRONG_SELF
        }];
        [alert addButtonWithTitle:@"提交" style:SimpleAlertActionStyle_Default action:^{
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
//    if (![self isNetworkReachable]) {
//        [self yx_showToast:@"网络异常，请检查网络后重试"];
//        return;
//    }
    [self setupUploadImageView];
    WEAK_SELF
    [[YXQADataManager sharedInstance]submitPaperWithModel:self.model beginDate:self.beginDate requestParams:self.requestParams completeBlock:^(NSError *error, QAPaperModel *reportModel) {
        STRONG_SELF
        [self.uploadImageView removeFromSuperview];
        [self.view nyx_stopLoading];
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
            [[YXQADataManager sharedInstance]clearPaperDurationWithPaperID:self.model.paperID];
            
            if (self.pType == YXPTypeGroupHomework && !reportModel.canShowHomeworkAnalysis) {
                [self showSubmitSuccessfullyTipViewWithEndDate:reportModel.homeworkEndDate];
                return;
            }
            
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
    SimpleAlertView *alert = [[SimpleAlertView alloc] init];
    alert.title = @"作业上传失败";
    alert.describe = @"请检查网络是否异常后重试";
    alert.image = [UIImage imageNamed:@"提交成功图标"];
    [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
        STRONG_SELF
    }];
    [alert addButtonWithTitle:@"再试一次" style:SimpleAlertActionStyle_Default action:^{
        STRONG_SELF
        [self submitPaper];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)showSubmitSuccessfullyTipViewWithEndDate:(NSDate *)date {
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[QAAnswerQuestionViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [formater stringFromDate:date];
    NSString *totalString = [NSString stringWithFormat:@"本作业被设定为: 截止时间后显示答案解析%@截止时间: %@",@"\n",dateString];
    WEAK_SELF
    SimpleAlertView *alert = [[SimpleAlertView alloc] init];
    alert.title = @"提交成功";
    alert.describe = totalString;
    alert.image = [UIImage imageNamed:@"提交成功图标"];
    [alert addButtonWithTitle:@"确定" style:SimpleAlertActionStyle_Default action:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showInView:self.navigationController.view];
}

- (void)setSelectedActionBlock:(SelectedActionBlock)block {
    self.buttonActionBlock = block;
}
@end

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

@interface QAAnswerSheetViewController ()
@property (nonatomic, strong) QAAnswerSheetView *sheetView;
@property (nonatomic, copy) SelectedActionBlock buttonActionBlock;
@end

@implementation QAAnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    self.title = self.model.paperTitle;
    [self setupObserver];
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
}

- (void)setSelectedActionBlock:(SelectedActionBlock)block {
    self.buttonActionBlock = block;
}
@end

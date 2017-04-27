//
//  YXQAReportViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAReportViewController_Pad.h"
#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXShareManager.h"
#import "YXGradientView.h"
#import "YXQAPaperStaticticData.h"
#import "YXQAAnalysisViewController_Pad.h"
#import "YXQAAnalysisDataConfig.h"

@interface YXQAReportViewController_Pad ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat questionCellHeight;
@property (nonatomic, assign) CGFloat bottomButtonHeight;
@end

@implementation YXQAReportViewController_Pad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[YXQAAnswerQuestionViewController_Pad class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.canDoExerciseAgain) {
        self.bottomButtonHeight = 60;
    }
    self.analysisDataConfig = [[YXQAAnalysisDataConfig alloc]init];
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"登录背景"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImage *greenBGImage = [UIImage yx_resizableImageNamed:@"塑料底板"];
    UIImageView *greenBgView = [[UIImageView alloc]initWithImage:greenBGImage];
    greenBgView.userInteractionEnabled = YES;
    [self.view addSubview:greenBgView];
    [greenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(69, 180, 102, 175));
    }];
    
    UIImage *paperImage = [UIImage yx_resizableImageNamed:@"纸张"];
    UIImageView *paperBgView = [[UIImageView alloc]initWithImage:paperImage];
    paperBgView.userInteractionEnabled = YES;
    paperBgView.clipsToBounds = YES;
    [greenBgView addSubview:paperBgView];
    [paperBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-33);
    }];
    
    UIImageView *pencilView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"做题铅笔"]];
    [self.view addSubview:pencilView];
    [pencilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.bounds.size.width-180-18);
        make.bottom.mas_equalTo(-116);
        make.size.mas_equalTo(CGSizeMake(144, 144));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(greenBgView.mas_top).mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(28+20, 28+20));
    }];

    if (self.pType != YXPTypeGroupHomework && ([YXShareManager isQQSupport] || [YXShareManager isWXAppSupport])) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:[UIImage imageNamed:@"分享icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(greenBgView.mas_top).mas_offset(-3);
            make.size.mas_equalTo(CGSizeMake(28+20, 28+20));
        }];
    }
    
    UIButton *titleButton = [[UIButton alloc]init];
    titleButton.userInteractionEnabled = NO;
    [titleButton setBackgroundImage:[UIImage imageNamed:@"练习报告夹子"] forState:UIControlStateNormal];
    if (self.pType == YXPTypeGroupHomework) {
        [titleButton setTitle:@"作业报告" forState:UIControlStateNormal];
    }else{
        [titleButton setTitle:@"练习报告" forState:UIControlStateNormal];
    }
    [titleButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(9, 0, -9, 0);
    [titleButton.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    [self.view addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38);
        make.centerX.mas_equalTo(-2);
        make.size.mas_equalTo(CGSizeMake(98, 66));
    }];
    
//    UIButton *viewAnalysisButton = [self yellowBottomButton];
//    [viewAnalysisButton setTitle:@"查看解析" forState:UIControlStateNormal];
//    [viewAnalysisButton addTarget:self action:@selector(goAnalysis) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:viewAnalysisButton];
//    UIView *s0 = [[UIView alloc] init];
//    [self.view addSubview:s0];
//    
//    UIButton *wrongAnalysisButton = [self yellowBottomButton];
//    [wrongAnalysisButton setTitle:@"错题解析" forState:UIControlStateNormal];
//    [wrongAnalysisButton addTarget:self action:@selector(goWrongAnalysis) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wrongAnalysisButton];
//    
//    BOOL hasWrong = FALSE;
//    for (YXQAItemBase *item in self.model.itemArray) {
//        // 主观题不计算在内
//        if (item.itemType == YXQAItemSubjective) {
//            continue;
//        }
//        if ([item answerState] != YXAnswerStateCorrect) {
//            hasWrong = TRUE;
//            break;
//        }
//    }
//    wrongAnalysisButton.enabled = hasWrong;
//    
//    [viewAnalysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(250);
//        make.height.mas_equalTo(50);
//        make.bottom.mas_equalTo(-30);
//    }];
//    [s0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(viewAnalysisButton.mas_right);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(30);
//    }];
//    [wrongAnalysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(s0.mas_right);
//        make.height.mas_equalTo(50);
//        make.bottom.mas_equalTo(-30);
//        make.width.mas_equalTo(viewAnalysisButton.mas_width);
//    }];
//    if (self.canDoExerciseAgain) {
//        UIView *s1 = [[UIView alloc] init];
//        [self.view addSubview:s1];
//        [s1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(wrongAnalysisButton.mas_right);
//            make.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(50);
//            make.width.mas_equalTo(s0.mas_width);
//        }];
//        UIButton *doAgainButton = [self blueBottomButton];
//        [doAgainButton setTitle:@"再练一组" forState:UIControlStateNormal];
//        [doAgainButton addTarget:self action:@selector(goDoAgain) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:doAgainButton];
//        [doAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(s1.mas_right);
//            make.right.mas_equalTo(-250);
//            make.height.mas_equalTo(50);
//            make.bottom.mas_equalTo(-30);
//            make.width.mas_equalTo(viewAnalysisButton.mas_width);
//        }];
//    }else{
//        [wrongAnalysisButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(s0.mas_right);
//            make.right.mas_equalTo(-250);
//            make.height.mas_equalTo(50);
//            make.bottom.mas_equalTo(-30);
//            make.width.mas_equalTo(viewAnalysisButton.mas_width);
//        }];
//    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
   
    //    if ([self hasSubjectiveQuestion]) {
//        self.subjectiveDelegate = [[YXQAReportSubjectiveDelegate_Pad alloc]initWithReportVC:self];
//        self.subjectiveDelegate.requestParams = self.requestParams;
//        self.tableView.dataSource = self.subjectiveDelegate;
//        self.tableView.delegate = self.subjectiveDelegate;
//    }else{
//        self.normalDelegate = [[YXQAReportNormalDelegate_Pad alloc]initWithReportVC:self];
//        self.normalDelegate.requestParams = self.requestParams;
//        self.tableView.dataSource = self.normalDelegate;
//        self.tableView.delegate = self.normalDelegate;
//    }
    [paperBgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
    
    YXGradientView *gradientView = [[YXGradientView alloc]initWithColor:[UIColor colorWithHexString:@"fff5cc"] orientation:YXGradientBottomToTop];
    [paperBgView addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(40);
    }];
    
    if (self.canDoExerciseAgain) {
        UIButton *doAgainButton = [self blueBottomButton];
        [doAgainButton setTitle:@"再练一组" forState:UIControlStateNormal];
        [doAgainButton addTarget:self action:@selector(goDoAgain) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doAgainButton];
        [doAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(155, 50));
        }];
    }

    
}


- (UIButton *)yellowBottomButton{
    UIButton *btn = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage yx_resizableImageNamed:@"黄按钮"];
    UIImage *highlightImage = [UIImage yx_resizableImageNamed:@"黄按钮-按下"];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    return btn;
}
- (UIButton *)blueBottomButton{
    UIButton *btn = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage yx_resizableImageNamed:@"兰按钮"];
    UIImage *highlightImage = [UIImage yx_resizableImageNamed:@"兰按钮-按下"];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"33ffff"]];
    return btn;
}
#pragma mark - button actions
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction{
    YXAlertView *alert = [YXAlertView alertWithMessage:@"分享到" style:YXAlertStyleAlert contentFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 306 - 15, 28, 306, 183)];
    [alert addCancelButton];
    @weakify(self);
    if ([YXShareManager isWXAppSupport]) {
        [alert addButtonWithTitle:@"" image:[UIImage imageNamed:@"微信"] highlightedImage:nil action:^{
            @strongify(self);
            [self shareWithType:YXShareType_WeChat];
        }];
        [alert addButtonWithTitle:@"" image:[UIImage imageNamed:@"朋友圈"] highlightedImage:nil action:^{
            @strongify(self);
            [self shareWithType:YXShareType_WeChatFriend];
        }];
    }
    if ([YXShareManager isQQSupport]) {
        [alert addButtonWithTitle:@"" image:[UIImage imageNamed:@"qq"] highlightedImage:nil action:^{
            @strongify(self);
            [self shareWithType:YXShareType_TcQQ];
        }];
        [alert addButtonWithTitle:@"" image:[UIImage imageNamed:@"qzone"] highlightedImage:nil action:^{
            @strongify(self);
            [self shareWithType:YXShareType_TcZone];
        }];
    }
    [alert show];
}

- (void)shareWithType:(YXShareType)shareType
{
    [[YXShareManager shareManager]shareWithType:shareType model:self.model networkErrorBlock:^{
        [self yx_showToast:@"网络异常，请稍后重试"];
    }];
}

- (void)goAnalysis{
    YXQAAnalysisViewController_Pad *vc = [[YXQAAnalysisViewController_Pad alloc]init];
    vc.requestParams = self.requestParams;
    vc.model = self.model;
    vc.pType = self.pType;
    vc.canDoExerciseFromKnp = self.canDoExerciseAgain;
    vc.analysisDataDelegate = self.analysisDataConfig;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goDoAgain
{
    @weakify(self);
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    [[YXExerciseListManager sharedInstance] requestQAWithParams:self.requestParams completion:^(YXIntelligenceQuestion *question, NSError *error) {
        @strongify(self);
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (question && !error) {
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc] init];
            vc.requestParams = self.requestParams;
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.pType = self.pType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        if (!self.titleCell) {
//            self.titleCell = [[YXQAReportTitleCell_Pad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            self.titleCell.title = self.model.title;
//            self.titleCell.duration = self.model.duration;
//            if (self.pType == YXPTypeGroupHomework) {
//                self.titleCell.image = [UIImage imageNamed:@"作业报告印章"];
//            }else{
//                self.titleCell.image = [UIImage imageNamed:@"练习印章"];
//            }
//        }
//        return self.titleCell;
//    }else{
//        if (!self.questionCell) {
//            self.questionCell = [[YXQAReportQuestionCell_Pad alloc]initWithPType:self.pType];
//            self.questionCell.model = self.model;
//            WEAK_SELF
//            self.questionCell.heightChangedBlock = ^(CGFloat height){
//                STRONG_SELF
//                self.questionCellHeight = height;
//                [self.tableView reloadData];
//            };
//            self.questionCell.jumpBlock = ^(YXQAItem *item, YXQAModel *model){
//                STRONG_SELF
//                YXQAItemPosition *p = [model positionWithItem:item];
//                YXQAAnalysisViewController_Pad *vc = [[YXQAAnalysisViewController_Pad alloc]init];
//                vc.requestParams = self.requestParams;
//                vc.model = model;
//                vc.firstLevel = p.firstLevel;
//                vc.secondLevel = p.secondLevel;
//                vc.pType = self.pType;
//                vc.canDoExerciseFromKnp = self.canDoExerciseAgain;
//                vc.analysisDataDelegate = self.analysisDataConfig;
//                [self.navigationController pushViewController:vc animated:YES];
//            };
//        }
//        return self.questionCell;
//    }
//}
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return 123;
//    }
//    return self.questionCellHeight;
//}
@end

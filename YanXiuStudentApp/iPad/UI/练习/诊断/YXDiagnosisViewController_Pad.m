//
//  YXDiagnosisViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXDiagnosisViewController_Pad.h"
#import "YXDiagnoseCell.h"
#import "YXKnp2Cell.h"
#import "YXKnpHeaderView.h"
#import "YXKnpFooterView.h"
#import "YXSubjectView.h"
#import "YXGetSubjectRequest.h"
#import "YXSubmitQuestionRequest.h"
#import "YXListLevel1KnpStateRequest.h"
#import "YXHistogramBackgroundView2.h"
#import "YXDiagnoseCell2.h"
#import "YXHistogramGradientView2.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "YXKnpCenterCell.h"
#import "YXKnpBottomCell.h"
#import "YXKnpHeaderView2.h"
#import "YXBottomGradientView.h"
#import "YXSubjectView2.h"
#import "YXKnp3View.h"
#import "YXExerciseListManager.h"
#import "YXDiagnosisDataManager.h"
#import "YXQAAnswerQuestionViewController_Pad.h"

@interface YXDiagnosisViewController_Pad ()<UITableViewDataSource,UITableViewDelegate,YXSubjectView2Delegate,YXKnp3ViewDelegate>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) UIButton *naviButton;
@property (nonatomic, strong) YXSubjectView2 *subjectView;
@property (nonatomic, strong) YXListKnpStateRequest *knpStateRequest;
@property (nonatomic, strong) YXDiagnoseCell2 *diagnoseCell;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) YXListLevel1KnpStateRequest *level1KnpStateRequest;
@property (nonatomic, strong) YXKnp3View *knp3View;

@end

@implementation YXDiagnosisViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self setupMock];
    [self setupUI];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        [self doSingleKnpRefresh];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)doSingleKnpRefresh {
    if (!self.currentIndexPath) {
        return;
    }
    
    NSString *subjectID = self.subject.eid;
    YXKnp1Item *knp1Item = self.model.knp1ItemArray[self.currentIndexPath.section-1];
    NSString *chapterID = knp1Item.knpId;
    [self yx_startLoading];
    @weakify(self);
    [[YXDiagnosisDataManager sharedInstance]updateDiagnosisDataWithSubjectID:subjectID chapterID:chapterID knp2Index:self.currentIndexPath.row model:self.model completeBlock:^(NSError *error) {
        @strongify(self); if (!self) return;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        self.diagnoseCell.model = self.model.chartModel;
        [self.tableView reloadData];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"登录背景"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImage *greenBGImage = [UIImage imageNamed:@"塑料底板"];
    greenBGImage = [greenBGImage stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    UIImageView *greenBgView = [[UIImageView alloc]initWithImage:greenBGImage];
    greenBgView.userInteractionEnabled = YES;
    [self.view addSubview:greenBgView];
    [greenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(69, 180, 42, 175));
    }];
    
//    UIImageView *nickImageView = [[UIImageView alloc]init];
//    UIImage *nickImage = [UIImage imageNamed:@"刻痕"];
//    nickImageView.image = nickImage;
//    [greenBgView addSubview:nickImageView];
//    [nickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-6);
//        make.bottom.mas_equalTo(-15);
//        make.size.mas_equalTo(nickImage.size);
//    }];
    
    UIImage *paperImage = [UIImage imageNamed:@"纸张"];
    paperImage = [paperImage stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    UIImageView *paperBgView = [[UIImageView alloc]initWithImage:paperImage];
    paperBgView.userInteractionEnabled = YES;
    paperBgView.clipsToBounds = YES;
    [greenBgView addSubview:paperBgView];
    [paperBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-37);
    }];
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [paperBgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
    [self.tableView registerClass:[YXDiagnoseCell2 class] forCellReuseIdentifier:@"YXDiagnoseCell2"];
    [self.tableView registerClass:[YXKnpCenterCell class] forCellReuseIdentifier:@"YXKnpCenterCell"];
    [self.tableView registerClass:[YXKnpBottomCell class] forCellReuseIdentifier:@"YXKnpBottomCell"];
    [self.tableView registerClass:[YXKnpHeaderView2 class] forHeaderFooterViewReuseIdentifier:@"YXKnpHeaderView2"];
    [self.tableView registerClass:[YXKnpFooterView class] forHeaderFooterViewReuseIdentifier:@"YXKnpFooterView"];
    
    YXBottomGradientView *gradientView = [[YXBottomGradientView alloc] initWithFrame:CGRectZero color:[UIColor colorWithHexString:@"fff5cc"]];
    [paperBgView addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(50);
    }];
    
//    UIImageView *pencilView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"铅笔"]];
//    [self.view addSubview:pencilView];
//    [pencilView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(94);
//        make.bottom.mas_equalTo(7);
//        make.size.mas_equalTo(CGSizeMake(88, 73));
//    }];
    
    self.naviButton = [[UIButton alloc]init];
    [self.naviButton setTitle:self.subject.name forState:UIControlStateNormal];
    self.naviButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.naviButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.naviButton.titleLabel.layer.shadowRadius = 0;
    self.naviButton.titleLabel.layer.shadowOpacity = 1;
    self.naviButton.titleEdgeInsets = UIEdgeInsetsMake(9, 4, -9, 31);
    self.naviButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.naviButton addTarget:self action:@selector(naviButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self setupNaviButtonWithSubjectSelectionFoldStatus:YES];
    [self.view addSubview:self.naviButton];
    [self.naviButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(90, 66));
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
}

- (void)setupNaviButtonWithSubjectSelectionFoldStatus:(BOOL)folded{
    if (folded) {
        [self.naviButton setBackgroundImage:[UIImage imageNamed:@"夹子按钮"] forState:UIControlStateNormal];
        [self.naviButton setBackgroundImage:[UIImage imageNamed:@"夹子按钮-按下"] forState:UIControlStateHighlighted];
        [self.naviButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
        self.naviButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    }else{
        [self.naviButton setBackgroundImage:[UIImage imageNamed:@"夹子按钮-可编辑"] forState:UIControlStateNormal];
        [self.naviButton setBackgroundImage:[UIImage imageNamed:@"夹子按钮-可编辑-按下"] forState:UIControlStateHighlighted];
        [self.naviButton setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
        self.naviButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"33ffff"].CGColor;
    }
}

- (void)naviButtonAction{
    if (self.subjectView.isShowing) {
        [self.subjectView hide];
        [self setupNaviButtonWithSubjectSelectionFoldStatus:YES];
    }else{
        if (!self.subjectView) {
            CGRect rect = [self.tableView convertRect:self.tableView.bounds toView:self.view];
            rect.size.height += 3;
            self.subjectView = [[YXSubjectView2 alloc]initWithFrame:rect numberPerRow:8];
            NSMutableArray *subjectArray = [NSMutableArray array];
            for (YXNodeElement *node in [YXGetSubjectManager sharedManager].subjectItem.data) {
                [subjectArray addObject:node.name];
            }
            self.subjectView.subjectArray = subjectArray;
            self.subjectView.delegate = self;
        }
        [self.view insertSubview:self.subjectView belowSubview:self.naviButton];
        [self.subjectView show];
        [self setupNaviButtonWithSubjectSelectionFoldStatus:NO];
    }
}

- (void)backAction{
    if (self.knp3View.superview) {
        [UIView animateWithDuration:.3 animations:^{
            self.knp3View.frame = CGRectMake(self.tableView.frame.size.width, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
            [self.naviButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(38);
                make.centerX.mas_equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(90, 66));
            }];
            [self.naviButton layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.knp3View removeFromSuperview];
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Mock
- (void)setupMock{
    self.model = [[YXDiagnoseModel alloc]init];
    YXDiagnoseChartModel *chartModel = [[YXDiagnoseChartModel alloc]init];
    chartModel.title = @"考点掌握度";
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self itemWithName:@"这是符合搜ID发生地" value:0.6]];
    [array addObject:[self itemWithName:@"屋里撒股份" value:0.8]];
    [array addObject:[self itemWithName:@"化学防晒地方发生" value:0.2]];
    [array addObject:[self itemWithName:@"低俗地方发生的发生" value:0.9]];
    [array addObject:[self itemWithName:@"这是十分厚实" value:0.5]];
    [array addObject:[self itemWithName:@"附属底" value:1]];
    [array addObject:[self itemWithName:@"什么东送饭舒服的方式地方" value:1.0]];
    [array addObject:[self itemWithName:@"这个文化宫额外" value:0.7]];
    [array addObject:[self itemWithName:@"饭后死对方会死" value:0.1]];
    [array addObject:[self itemWithName:@"饭后死对方会死" value:0.1]];
    chartModel.chartItemArray = array;
    self.model.chartModel = chartModel;
    
    NSMutableArray *knp3Array = [NSMutableArray array];
    [knp3Array addObject:[self knp3ItemWithName:@"三级考点111" value:@"12%"]];
    [knp3Array addObject:[self knp3ItemWithName:@"三级考点222" value:@"50%"]];
    [knp3Array addObject:[self knp3ItemWithName:@"三级考点333" value:@"78%"]];
    
    YXKnp2Item *item1 = [[YXKnp2Item alloc]init];
    item1.title = @"有理数";
    item1.knpCount = 26;
    item1.knpMasterCount = 1;
    item1.knp3ItemArray = knp3Array;
    
    YXKnp2Item *item2 = [[YXKnp2Item alloc]init];
    item2.title = @"二级考点xxx";
    item2.knpCount = 23;
    item2.knpMasterCount = 0;
    item2.knp3ItemArray = knp3Array;
    
    YXKnp2Item *item3 = [[YXKnp2Item alloc]init];
    item3.title = @"有理数222";
    item3.knpCount = 24;
    item3.knpMasterCount = 1;
    item3.knp3ItemArray = knp3Array;
    
    YXKnp2Item *item4 = [[YXKnp2Item alloc]init];
    item4.title = @"二级考点耳机考点考点啊啊啊风格奋斗史个人";
    item4.knpCount = 26;
    item4.knpMasterCount = 1;
    item4.knp3ItemArray = knp3Array;
    
    YXKnp1Item *knp1Item1 = [[YXKnp1Item alloc]init];
    knp1Item1.title = @"数与式啦啦啦啦啦啦啦啦啦啦啦发货我复合物";
    knp1Item1.levelDescription = @"考点完全掌握";
    knp1Item1.knpCount = 48;
    knp1Item1.knpMasterCount = 1;
    knp1Item1.knp2ItemArray = @[item1,item2];
    
    YXKnp1Item *knp1Item2 = [[YXKnp1Item alloc]init];
    knp1Item2.title = @"一级考点";
    knp1Item2.levelDescription = @"考点完全掌握";
    knp1Item2.knpCount = 48;
    knp1Item2.knpMasterCount = 1;
    knp1Item2.knp2ItemArray = @[item3,item4];
    
    self.model.knp1ItemArray = @[knp1Item1,knp1Item2];
    
}
- (YXDiagnoseChartItem *)itemWithName:(NSString *)name value:(CGFloat)value{
    YXDiagnoseChartItem *item = [[YXDiagnoseChartItem alloc]init];
    item.name = name;
    item.value = value;
    return item;
}
- (YXKnp3Item *)knp3ItemWithName:(NSString *)name value:(NSString *)value{
    YXKnp3Item *item = [[YXKnp3Item alloc]init];
    item.title = name;
    item.level = value;
    item.levelDescription = @"掌握度";
    return item;
}

#pragma mark - YXSubjectView2Delegate
- (void)subjectView:(YXSubjectView2 *)subjectView didSelectItemWithIndex:(NSInteger)index{
    [self setupNaviButtonWithSubjectSelectionFoldStatus:YES];
    YXNodeElement *node = [YXGetSubjectManager sharedManager].subjectItem.data[index];
    if ([self.subject.eid isEqualToString:node.eid]) {
        return;
    }
    self.subject = node;
    [self.knpStateRequest stopRequest];
    self.knpStateRequest = [[YXListKnpStateRequest alloc]init];
    self.knpStateRequest.subjectId = node.eid;
    self.knpStateRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    [self yx_startLoading];
    self.naviButton.userInteractionEnabled = NO;
    @weakify(self);
    [self.knpStateRequest startRequestWithRetClass:[YXListKnpStateRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (!self) {
            return;
        }
        [self yx_stopLoading];
        self.naviButton.userInteractionEnabled = YES;
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXDiagnoseModel *model = [YXDiagnoseModel modelFromListKnpStateRequestItem:retItem];
        self.model = model;
        [self.naviButton setTitle:node.name forState:UIControlStateNormal];
        self.diagnoseCell.model = model.chartModel;
        [self.tableView reloadData];
        self.tableView.contentOffset = CGPointZero;
    }];
}

- (void)subjectViewCanceled:(YXSubjectView2 *)subjectView{
    [self setupNaviButtonWithSubjectSelectionFoldStatus:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + self.model.knp1ItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        YXKnp1Item *item = self.model.knp1ItemArray[section-1];
        return item.knp2ItemArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (!self.diagnoseCell) {
            self.diagnoseCell = [tableView dequeueReusableCellWithIdentifier:@"YXDiagnoseCell2"];
            self.diagnoseCell.model = self.model.chartModel;
        }
        return self.diagnoseCell;
    }else{
        YXKnp1Item *knp1Item = self.model.knp1ItemArray[indexPath.section-1];
        if (indexPath.row == knp1Item.knp2ItemArray.count-1) {
            YXKnpBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXKnpBottomCell"];
            cell.item = knp1Item.knp2ItemArray[indexPath.row];
            return cell;
        }else{
            YXKnpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXKnpCenterCell"];
            cell.item = knp1Item.knp2ItemArray[indexPath.row];
            return cell;
        }
    }
    
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXKnpHeaderView2 *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXKnpHeaderView2"];
    header.item = self.model.knp1ItemArray[section-1];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXKnpFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXKnpFooterView"];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 282;
    }
    YXKnp1Item *knp1Item = self.model.knp1ItemArray[indexPath.section-1];
    if (indexPath.row == knp1Item.knp2ItemArray.count - 1) {
        return 40;
    }
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.currentIndexPath = nil;
        return;
    }
    
    self.currentIndexPath = indexPath;
    
    [self.knp3View removeFromSuperview];
    self.knp3View = [[YXKnp3View alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    YXKnp1Item *knp1Item = self.model.knp1ItemArray[indexPath.section-1];
    self.knp3View.item = knp1Item.knp2ItemArray[indexPath.row];
    self.knp3View.delegate = self;
    [self.tableView.superview addSubview:self.knp3View];
    self.tableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.knp3View.frame = self.tableView.frame;
        [self.naviButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-70);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(90, 66));
        }];
        [self.naviButton layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = YES;
    }];
}

#pragma mark - YXKnp3ViewDelegate
- (void)knp3View:(YXKnp3View *)view didSelectIndex:(NSInteger)index{
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    
    YXKnp1Item *knp1Item = self.model.knp1ItemArray[self.currentIndexPath.section-1];
    YXKnp3Item *item = view.item.knp3ItemArray[index];
    YXQARequestParams *params = [[YXQARequestParams alloc] init];
    params.subjectId = self.subject.eid;
    params.stageId = [YXUserManager sharedManager].userModel.stageid;
    params.type = YXExerciseListTypeQuiz;
    params.segment = YXExerciseListSegmentTestItem;
    params.questNum = @"10";
    params.fromType = @"2";
    params.chapterId = knp1Item.knpId;
    
    params.sectionId = view.item.knpId;
    params.cellId = item.knpId;
    @weakify(self);
    [[YXExerciseListManager sharedInstance] requestQAWithParams:params completion:^(YXIntelligenceQuestion *question, NSError *error) {
        @strongify(self);
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (question && !error) {
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc] init];
            vc.requestParams = params;
            vc.model = [QAPaperModel modelFromRawData:question];
            vc.pType = YXPTypeIntelligenceExercise;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

@end

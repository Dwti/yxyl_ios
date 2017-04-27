//
//  YXExerciseHistoryChooseChapterKnpViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXExerciseHistoryChooseChapterKnpViewController_Pad.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"
#import "YXChapterKnpointEmptyView.h"

#import "YXGetEditionsRequest.h"
#import "YXGetQuestionListRequest.h"
#import "YXGetQuestionReportRequest.h"
#import "YXExerciseHistoryListFetcher.h"

#import "YXChooseVolumnButton.h"
#import "YXChooseVolumnView.h"
#import "YXChapterPointSegmentControl.h"

#import "YXHistoryCell.h"
#import "YXDashLineCell.h"

#import "YXQAReportViewController_Pad.h"
#import "YXQAAnswerQuestionViewController_Pad.h"
#import "YXSplitViewController.h"

@interface YXExerciseHistoryChooseChapterKnpViewController_Pad ()

@property (nonatomic, strong) YXGetQuestionListRequest *request;
@property (nonatomic, strong) YXExerciseEmptyView *myEmptyView;
@property (nonatomic, strong) YXGetQuestionReportRequest *reportRequest;
@property (nonatomic, strong) YXExerciseHistoryListFetcher *chapterListFetcher;
@property (nonatomic, strong) YXExerciseHistoryByKnowListFetcher *knpListFetcher;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) YXExerciseListSegment segment;


@property (nonatomic, strong) UIImageView *treeBackgroundView;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) YXChooseVolumnButton *chooseVolumnButton;
@property (nonatomic, strong) YXChooseVolumnView *chooseVolumenView;
@property (nonatomic, strong) YXChapterPointSegmentControl *chooseChapterPointControl;
@property (nonatomic, strong) UIButton *zhenDuanButton;
@end

@implementation YXExerciseHistoryChooseChapterKnpViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    self.treeBackgroundView = [[UIImageView alloc] init];
    self.treeBackgroundView.image = [UIImage imageNamed:@"我的背景-Pad"];
    self.treeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.treeBackgroundView];
    [self.treeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    self.segment = YXExerciseListSegmentChapter;
    self.title = self.subject.name;
    
    _myEmptyView = [[YXExerciseEmptyView alloc] init];
    _myEmptyView.hidden = YES;
    [self.view addSubview:_myEmptyView];
    [_myEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    YXExerciseHistoryListFetcher *fetcher = [[YXExerciseHistoryListFetcher alloc] init];
    fetcher.subject = self.subject;
    @weakify(self);
    fetcher.emptyBlock = ^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self firstPageRequestBack];
        if (error.code != 65) { // 业务逻辑错误
            self.myEmptyView.hidden = NO;
            if (error.localizedDescription) {
                [self.myEmptyView setEmptyText:error.localizedDescription];
            }
        }else{
            [YXChapterKnpointEmptyView showWithType:EChapterEmpty addToView:self.view];
            [self.view bringSubviewToFront:self.topContainerView];
        }
    };
    fetcher.errorBlock = ^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        [self firstPageRequestBack];
        self.errorView.hidden = NO;
        [self.view bringSubviewToFront:self.errorView];
        [self.view bringSubviewToFront:self.topContainerView];
    };
    self.chapterListFetcher = fetcher;
    YXExerciseHistoryByKnowListFetcher *knowFetcher = [[YXExerciseHistoryByKnowListFetcher alloc] init];
    knowFetcher.subject = self.subject;
    knowFetcher.emptyBlock = ^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self firstPageRequestBack];
        if (error.code != 65) { // 业务逻辑错误
            self.myEmptyView.hidden = NO;
            if (error.localizedDescription) {
                [self.myEmptyView setEmptyText:error.localizedDescription];
            }
        }else{
            [YXChapterKnpointEmptyView showWithType:EKnpointEmpty addToView:self.view];
            [self.view bringSubviewToFront:self.topContainerView];
        }
    };
    knowFetcher.errorBlock = ^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        [self firstPageRequestBack];
        self.errorView.hidden = NO;
        [self.view bringSubviewToFront:self.errorView];
        [self.view bringSubviewToFront:self.topContainerView];
    };
    self.knpListFetcher = knowFetcher;
    self.dataFetcher = fetcher;
    
    if ([self.subject.data hasKnp]) {
        //[self setupSegmentedControl];
    }
    [self registerNotifications];
    [self firstPageFetch];
    
    [self setupSubviews20];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHistoryCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self yx_startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataFetcher stop];
    [[YXGetEditionsManager sharedManager] stopRequest];
    [self.request stopRequest];
}

#pragma mark -
- (void)firstPageRequestBack
{
    self.errorView.hidden = YES;
    self.emptyView.hidden = YES;
    self.myEmptyView.hidden = YES;
    [YXChapterKnpointEmptyView hideForView:self.view];
}

#pragma mark -
- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(submitQuestionSuccess:)
                   name:YXSubmitQuestionSuccessNotification
                 object:nil];
}

- (void)submitQuestionSuccess:(NSNotification *)notification
{
    [self firstPageFetch];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
- (void)setupSegmentedControl
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"章节",@"考点"]];
    segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
}

- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    self.segment = sender.selectedSegmentIndex;
    if (self.segment == YXExerciseListSegmentChapter) {
        self.dataFetcher = self.chapterListFetcher;
    } else {
        self.dataFetcher = self.knpListFetcher;
        self.navigationItem.rightBarButtonItems = nil;
    }
    [self firstPageFetch];
}

- (void)requestQuestionListWithPaperId:(NSString *)paperId
{
    [self.request stopRequest];
    self.request = [[YXGetQuestionListRequest alloc] init];
    self.request.paperId = paperId;
    @weakify(self);
    [self yx_startLoading];
    self.segmentedControl.enabled = NO;
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.segmentedControl.enabled = YES;
        YXIntelligenceQuestionListItem *item = retItem;
        if (item.data.count > 0 && !error) {
            YXQARequestParams *param = [[YXQARequestParams alloc] init];
            YXIntelligenceQuestion *q = item.data.firstObject;
            param.stageId = q.stageid;
            param.subjectId = q.subjectid;
            param.editionId = q.bedition;
            param.volumeId = q.volume;
            param.chapterId = q.chapterid;
            param.sectionId = q.sectionid;
            param.questNum = @"10";
            param.cellId = q.cellid;
            param.segment = self.segment;
            YXQAAnswerQuestionViewController_Pad *vc = [[YXQAAnswerQuestionViewController_Pad alloc]init];
            vc.model = [QAPaperModel modelFromRawData:q];
            vc.requestParams = param;
            vc.pType = YXPTypeExerciseHistory;
            [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)requestReportDataWithPaperId:(NSString *)paperId{
    [self.reportRequest stopRequest];
    self.reportRequest = [[YXGetQuestionReportRequest alloc]init];
    self.reportRequest.ppid = paperId;
    self.reportRequest.flag = @"1";
    
    @weakify(self)
    [self yx_startLoading];
    self.segmentedControl.enabled = NO;
    [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self)
        [self yx_stopLoading];
        self.segmentedControl.enabled = YES;
        if (error) {
            [self yx_showToast:error.localizedDescription];
        }else{
            [self goToReportVCWithItem:retItem];
        }
    }];
}
- (void)goToReportVCWithItem:(YXIntelligenceQuestionListItem *)item{
    YXQARequestParams *param = [[YXQARequestParams alloc] init];
    YXIntelligenceQuestion *q = item.data.firstObject;
    param.stageId = q.stageid;
    param.subjectId = q.subjectid;
    param.editionId = q.bedition;
    param.volumeId = q.volume;
    param.chapterId = q.chapterid;
    param.sectionId = q.sectionid;
    param.questNum = @"10";
    param.cellId = q.cellid;
    param.segment = self.segment;
    YXQAReportViewController_Pad *vc = [[YXQAReportViewController_Pad alloc] init];
    vc.model = [QAPaperModel modelFromRawData:q];
    vc.requestParams = param;
    [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 0;
    }
    if (self.dataArray.count > 0) {
        self.myEmptyView.hidden = YES;
    }
    return self.dataArray.count * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        YXDashLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dash"];
        cell.realWidth = 7;
        cell.dashWidth = 7;
        cell.preferedGapToCellBounds = 90;
        cell.bHasShadow = NO;
        cell.realColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        YXHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.edgeInterval  = 75.f;
        cell.clockInterval = 160.f;
        [cell updateWithData:self.dataArray[indexPath.row/2]];
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            if (indexPath.row % 2) {
                
            } else {
                YXGetPracticeHistoryItem_Data *data = self.dataArray[indexPath.row/2];
                if ([data isFinished]) {
                    [self requestReportDataWithPaperId:data.paperId];
                } else {
                    [self requestQuestionListWithPaperId:data.paperId];
                }
            }
        };
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return 2;
    }
    
    return 92;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row % 2) {
        
    } else {
        YXGetPracticeHistoryItem_Data *data = self.dataArray[indexPath.row/2];
        if ([data isFinished]) {
            [self requestReportDataWithPaperId:data.paperId];
        } else {
            [self requestQuestionListWithPaperId:data.paperId];
        }
    }
}

#pragma mark - 2.0

// 以下代码纯属从ExerciseListVC里copy / paste，没怎么动脑

- (void)setupSubviews20 {
    if (!self.topContainerView) {
        self.topContainerView = [[UIView alloc] init];
        self.topContainerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
        self.topContainerView.clipsToBounds = YES;
        [self.view addSubview:self.topContainerView];
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"007373"];
        [self.topContainerView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        
        [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-56);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(58);
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topContainerView.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
        }];
                
        [self.view layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.chooseVolumnButton) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.topContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            [self.view layoutIfNeeded];
        }];
        
        self.chooseVolumnButton = [[YXChooseVolumnButton alloc] init];
        self.chooseVolumnButton.bExpand = NO;
        [self.topContainerView addSubview:self.chooseVolumnButton];
        [self.chooseVolumnButton addTarget:self action:@selector(chooseVolumnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseVolumnButton updateWithTitle:@"这里应该没有"];
        self.chooseVolumnButton.center = CGPointMake(self.topContainerView.frame.size.width - self.chooseVolumnButton.frame.size.width * 0.5 - 10, self.topContainerView.frame.size.height * 0.5);
        
        self.chooseChapterPointControl = [[YXChapterPointSegmentControl alloc] init];
        [self.topContainerView addSubview:self.chooseChapterPointControl];
        [self.chooseChapterPointControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(self.chooseChapterPointControl.frame.size);
        }];
        [self.chooseChapterPointControl addTarget:self action:@selector(chapterPointValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.zhenDuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zhenDuanButton setTitle:@"诊断" forState:UIControlStateNormal];
        [self.zhenDuanButton setTitleColor:[UIColor colorWithHexString:@"ffdb4d"] forState:UIControlStateNormal];
        self.zhenDuanButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.zhenDuanButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
        self.zhenDuanButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.zhenDuanButton.titleLabel.layer.shadowOpacity = 1;
        self.zhenDuanButton.titleLabel.layer.shadowRadius = 0;
        [self.zhenDuanButton setImage:[UIImage imageNamed:@"诊断icon"] forState:UIControlStateNormal];
        [self.zhenDuanButton setImage:[UIImage imageNamed:@"诊断icon按下"] forState:UIControlStateHighlighted];
        [BaseViewController update_h_title_image_forButton:self.zhenDuanButton
                                                withHeight:50
                                                leftMargin:10
                                   gapBetweenTitleAndImage:7
                                               rightMargin:10];
        [self.zhenDuanButton addTarget:self action:@selector(zhenDuanAction) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:self.zhenDuanButton];
        [self.zhenDuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(self.zhenDuanButton.frame.size);
            make.right.mas_equalTo(0);
        }];
        
        self.chooseVolumnButton.hidden = YES;
        self.zhenDuanButton.hidden = YES;
        [self.view bringSubviewToFront:self.topContainerView];
    }
}

- (void)chooseVolumnAction:(YXChooseVolumnButton *)sender {
    self.chooseVolumnButton.center = CGPointMake(self.topContainerView.frame.size.width - self.chooseVolumnButton.frame.size.width * 0.5 - 10, self.topContainerView.frame.size.height * 0.5);
    [self.chooseVolumnButton layoutIfNeeded];
    sender.bExpand = !sender.bExpand;
    
    if (sender.bExpand) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.chooseVolumenView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(58);
                make.bottom.left.right.mas_equalTo(0);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.chooseVolumenView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-20);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)reloadVolumeChooseView
{
    return;
}

- (void)chapterPointValueChanged:(YXChapterPointSegmentControl *)seg
{
    self.errorView.hidden = YES;
    self.emptyView.hidden = YES;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    
    self.segment = seg.curSelectedIndex;
    if (self.segment == YXExerciseListSegmentChapter) {
        self.dataFetcher = self.chapterListFetcher;
    } else {
        self.dataFetcher = self.knpListFetcher;
        self.navigationItem.rightBarButtonItems = nil;
    }
    [self firstPageFetch];
}

- (void)zhenDuanAction {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

@end

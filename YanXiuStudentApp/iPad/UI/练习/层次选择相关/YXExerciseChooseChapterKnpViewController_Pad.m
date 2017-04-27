//
//  YXExerciseChooseChapterKnpViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/27.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseChapterKnpViewController_Pad.h"
#import "YXExerciseTreeView.h"
#import "YXExerciseTreeCell.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"
#import "YXChapterKnpointEmptyView.h"
#import "YXChooseVolumnButton.h"
#import "YXChooseVolumnView.h"
#import "YXChapterPointSegmentControl.h"

#import "YXGetEditionsRequest.h"
#import "YXSubmitQuestionRequest.h"

@interface YXExerciseChooseChapterKnpViewController_Pad ()<YXExerciseTreeViewDelegate>

@property (nonatomic, strong) YXExerciseTreeView *treeView;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;

@property (nonatomic, strong) YXExerciseListModel *model;
@property (nonatomic, strong) YXExerciseListModel *testItemModel;
@property (nonatomic, strong) NSArray *volumeItem;
@property (nonatomic, strong) YXNodeElement *volume;
@property (nonatomic, assign) YXExerciseListSegment segment;
@property (nonatomic, assign) BOOL hasKnp;

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) YXChooseVolumnButton *chooseVolumnButton;
@property (nonatomic, strong) YXChooseVolumnView *chooseVolumenView;
@property (nonatomic, strong) YXChapterPointSegmentControl *chooseChapterPointControl;
@property (nonatomic, strong) UIButton *zhenDuanButton;
@end

@implementation YXExerciseChooseChapterKnpViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self yx_setupLeftBackBarButtonItem];
    self.title = self.subject.name;
    self.segment = YXExerciseListSegmentChapter;
    self.delegate = self;
    
    [self setupSubviews];
    [self setupSubviews20];
    [self loadExerciseListData];
    
    // TBD : 刷新考点，暂时先不考虑
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil] subscribeNext:^(id x) {
    //        @strongify(self); if (!self) return;
    //        [self requestExerciseList];
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (YXExerciseListParams *)listParams
{
    YXExerciseListParams *params = [[YXExerciseListParams alloc] init];
    params.stageId = [YXUserManager sharedManager].userModel.stageid;
    params.subjectId = self.subject.subjectID;
    params.editionId = self.subject.edition.editionId;
    params.volumeId = self.volume.eid;
    params.segment = self.segment;
    return params;
}

- (void)reloadDataAfterDelete
{
    [self requestExerciseListAfterDelete:YES];
}

#pragma mark - UI

- (void)setupSubviews
{
    self.treeView = [[YXExerciseTreeView alloc] initWithFrame:CGRectZero];
    self.treeView.delegate = self;
    self.treeView.backgroundColor = [UIColor clearColor];
    self.treeView.comeFromKnp = (self.listParams.segment == YXExerciseListSegmentTestItem);
    [self.view addSubview:self.treeView];
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self loadExerciseListData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    self.emptyView = [[YXExerciseEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.emptyView.hidden = YES;
}

- (void)showEmptyViewWithText:(NSString *)text
{
    self.treeView.hidden = YES;
    if (self.segment == YXExerciseListSegmentTestItem) {
        [YXChapterKnpointEmptyView showWithType:EKnpointEmpty addToView:self.view];
        [self.view bringSubviewToFront:self.topContainerView];
        return;
    }
    if (self.hasKnp
        && self.segment == YXExerciseListSegmentChapter
        && self.volumeItem.count <= 1) { // 多个册时不显示此为空提示
        [YXChapterKnpointEmptyView showWithType:EChapterEmpty addToView:self.view];
        [self.view bringSubviewToFront:self.topContainerView];
        return;
    }
    if (text) {
        [self.emptyView setEmptyText:text];
    }
    self.emptyView.hidden = NO;
}

- (void)hideStatusView
{
    [YXChapterKnpointEmptyView hideForView:self.view];
    self.emptyView.hidden = YES;
    self.errorView.hidden = YES;
    self.treeView.hidden = NO;
}

#pragma mark - Data

- (void)loadExerciseListData
{
    switch (self.segment) {
        case YXExerciseListSegmentChapter:
            [self requestVolumeList];
            break;
        case YXExerciseListSegmentTestItem:
            [self requestExerciseList];
            break;
    }
}

// 请求册数据
- (void)requestVolumeList
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(requestVolumeListWithCompletion:)]) {
        return;
    }
    @weakify(self);
    [self yx_startLoading];
    [self.delegate requestVolumeListWithCompletion:^(NSArray *volumeItem, YXNodeElement *currentVolume, BOOL hasKnp, NSError *error) {
        @strongify(self); if (!self) return;
        [self yx_stopLoading];
        [self hideStatusView];
        if (error && !volumeItem) {
            self.treeView.hidden = YES;
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            self.errorView.hidden = NO;
            return;
        }
        
        self.hasKnp = hasKnp;
        
        [[[YXSavedExercisesDatabaseManager alloc] init] updateVolume:volumeItem];
        if (!volumeItem || volumeItem.count == 0) {
            [self showEmptyViewWithText:error.localizedDescription];
            return;
        }
        
        self.volumeItem = volumeItem;
        self.volume = currentVolume;
        [self reloadDataForVolumeItem];
    }];
}

// 练习目录列表请求入口，通过segment区分章节和考点
- (void)requestExerciseList
{
    [self requestExerciseListAfterDelete:NO];
}

- (void)requestExerciseListAfterDelete:(BOOL)isDelete
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(requestExerciseListWithCompletion:)]) {
        return;
    }
    @weakify(self);
    [self yx_startLoading];
    [self.delegate requestExerciseListWithCompletion:^(YXExerciseListModel *model, NSError *error) {
        @strongify(self); if (!self) return;
        [self yx_stopLoading];
        [self hideStatusView];
        
        if (self.segment == YXExerciseListSegmentChapter) {
            self.model = model;
        } else {
            self.testItemModel = model;
        }
        
        if (!model && error) {
            self.treeView.hidden = YES;
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            self.errorView.hidden = NO;
            return;
        }
        
        if (model && model.data.count == 0) {
            if (isDelete) {
                [self deleteVolumeForEmptyItem];
            }
            [self showEmptyViewWithText:error.localizedDescription];
        }
        [self reloadTreeViewData];
    }];
}

- (void)reloadTreeViewData
{
    [self.treeView reloadData];
}

- (void)deleteVolumeForEmptyItem
{
    if (self.segment == YXExerciseListSegmentChapter
        && self.delegate
        && [self.delegate respondsToSelector:@selector(deleteVolumeWithId:completion:)]) {
        @weakify(self);
        [self.delegate deleteVolumeWithId:self.volume.eid completion:^(NSArray *volumeItem, YXNodeElement *currentVolume) {
            @strongify(self); if (!self) return;
            self.volumeItem = volumeItem;
            self.volume = currentVolume;
            [self reloadDataForVolumeItem];
        }];
    }
}

- (void)reloadDataForVolumeItem
{
    if (self.volumeItem.count > 0) {
        if (!self.volume) {
            self.volume = self.volumeItem[0];
        }
        [self reloadVolumeChooseView];
        [self requestExerciseList];
    }
}

#pragma mark - YXExerciseTreeViewDelegate

- (Class)cellClass
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellClass)]) {
        return [self.delegate cellClass];
    }
    return [YXExerciseTreeCell class];
}

- (NSArray *)treeItem
{
    switch (self.segment) {
        case YXExerciseListSegmentChapter:
            return self.model.data;
        case YXExerciseListSegmentTestItem:
            return self.testItemModel.data;
    }
}

- (void)didSelectWithElementL0:(YXNodeElement *)elementL0
                     elementL1:(YXNodeElement *)elementL1
                     elementL2:(YXNodeElement *)elementL2
{
    switch (self.segment) {
        case YXExerciseListSegmentChapter:
            if (self.delegate && [self.delegate respondsToSelector:@selector(showQuestionWithChapter:section:cell:)]) {
                [self.delegate showQuestionWithChapter:elementL0
                                               section:elementL1
                                                  cell:elementL2];
            }
            break;
        case YXExerciseListSegmentTestItem:
            if (self.delegate && [self.delegate respondsToSelector:@selector(showQuestionWithKnpL0:knpL1:knpL2:)]) {
                [self.delegate showQuestionWithKnpL0:elementL0
                                               knpL1:elementL1
                                               knpL2:elementL2];
            }
            break;
    }
}


#pragma mark - 2.0

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
        
        [self.treeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topContainerView.mas_bottom);
            //make.bottom.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.leftRightGapForTreeView);
            make.right.mas_equalTo(-self.leftRightGapForTreeView);
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
        [self.chooseVolumnButton updateWithTitle:self.volume.name];
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
        
        
        self.chooseVolumnButton.hidden = NO;
        self.zhenDuanButton.hidden = YES;
        
        if (self.volumeItem.count == 0) {
            self.chooseVolumnButton.hidden = YES;
        } else {
            self.chooseVolumnButton.hidden = NO;
        }
        
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
    if (!self.chooseVolumenView) {
        self.chooseVolumenView = [[YXChooseVolumnView alloc] init];
        @weakify(self);
        self.chooseVolumenView.chooseBlock = ^(NSInteger index) {
            @strongify(self); if (!self) return;
            self.volume = self.volumeItem[index];
            
            [self.chooseVolumnButton updateWithTitle:self.volume.name];
            self.chooseVolumnButton.bExpand = YES;
            [self chooseVolumnAction:self.chooseVolumnButton];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(saveCacheWithVolume:)]) {
                [self.delegate saveCacheWithVolume:self.volume];
            }
            [self requestExerciseList];
        };
        
        [self.chooseVolumenView updateWithDatas:[YXGetEditionsManager volumeNamesWithVolumeItem:self.volumeItem]
                                  selectedIndex:[YXGetEditionsManager volumeIndexWithVolumeItem:self.volumeItem volumeId:self.volume.eid]];
        
        [self.view addSubview:self.chooseVolumenView];
        [self.view bringSubviewToFront:self.topContainerView];
        
        [self.chooseVolumenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
    }
}

- (void)chapterPointValueChanged:(YXChapterPointSegmentControl *)seg
{
    if (self.chooseVolumnButton.bExpand) {
        [self chooseVolumnAction:self.chooseVolumnButton];
    }
    
    
    self.segment = seg.curSelectedIndex;
    switch (self.segment) {
        case YXExerciseListSegmentChapter:
            self.chooseVolumnButton.hidden = NO;
            self.zhenDuanButton.hidden = YES;
            self.treeView.comeFromKnp = NO;
            if (self.volumeItem.count == 0) {
                self.chooseVolumnButton.hidden = YES;
            } else {
                self.chooseVolumnButton.hidden = NO;
            }
            break;
        case YXExerciseListSegmentTestItem: {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showDiagnosticsTips)]) {
                //[self.delegate showDiagnosticsTips];
                self.chooseVolumnButton.hidden = YES;
                self.zhenDuanButton.hidden = YES;
            } else {
                self.chooseVolumnButton.hidden = YES;
                self.zhenDuanButton.hidden = YES;
            }
            self.treeView.comeFromKnp = YES;
        }
            break;
    }
    
    if ([self treeItem]) {
        [self hideStatusView];
        [self reloadTreeViewData];
    } else {
        [self loadExerciseListData];
    }
}

- (void)zhenDuanAction {
    
}

@end

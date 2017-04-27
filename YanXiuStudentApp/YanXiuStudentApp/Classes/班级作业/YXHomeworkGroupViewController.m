//
//  YXHomeworkGroupViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkGroupViewController.h"
#import "YXHomeworkGroupMock.h"
#import "EEAlertView.h"
#import "YXCommonErrorView.h"
#import "UIView+YXScale.h"

#import "YXSearchClassViewController.h"
#import "YXHomeworkViewController.h"
#import "YXHomeworkToDoViewController.h"
#import "YXClassInfoViewController.h"

#import "YXClassHomeworkFetcher.h"
#import "YXJoinClassRequest.h"
#import "YXExitClassRequest.h"
#import "YXSubmitQuestionRequest.h"
#import "YXCancelReplyClassRequest.h"

#import "YXUnfinishedHeaderCell.h"
#import "YXDashLineCell.h"
#import "YXHomeworkSubjectCell.h"
#import "YXRedManager.h"
#import "YXRecordManager.h"
#import "AddClassPromptView.h"
#import "YXHomeworkListFetcher.h"

@interface YXHomeworkGroupViewController ()

@property (nonatomic, assign) BOOL shouldReload;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, assign) YXClassActionType actionType;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) UIView *emptyWorkView;

@end

@implementation YXHomeworkGroupViewController

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
        self.errorView = [[YXCommonErrorView alloc] init];
        self.emptyView = self.emptyWorkView;
        self.bIsGroupedTableViewStyle = YES;
        
        YXClassHomeworkFetcher *fetcher = [[YXClassHomeworkFetcher alloc] init];
        WEAK_SELF
        fetcher.classJoinBlock = ^(YXHomeworkListGroupsItem *item, HomeworkFetchState state) {
            STRONG_SELF
            [self yx_stopLoading];
            [self.alertView hide];
            if (state == HomeworkFetch_NeedAddClass) {
                [self handleAddClass];
            } else if (state == HomeworkFetch_NeedVerify) {
                [self handleVerifyUserWithItem:item];
            } else if (state == HomeworkFetch_Error) {
                [self handleHomeworkRequestError];
            } else {
                [self handleHomeworkRequestSuccessWithItem:item];
            }
        };
        self.dataFetcher = fetcher;
    }
    return self;
}

- (void)handleAddClass {
    [self clearAndReloadData];
    self.rightButton = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"添加"] highLightedImage:nil];
    self.actionType = YXClassActionTypeJoin;
    self.classId = nil;
    self.emptyView.hidden = YES;
    
    AddClassPromptView *addClassView = [[AddClassPromptView alloc]initWithFrame:CGRectMake(0, 0, 306 * [UIView scale], 150)];
    WEAK_SELF
    [addClassView setHelpAction:^{
        STRONG_SELF
        id vc = [NSClassFromString(@"YXAddClassHelpViewController") new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [addClassView setJoinAction:^{
        STRONG_SELF
        [self goSearchClass];
    }];
    self.alertView = [[EEAlertView alloc]init];
    self.alertView.contentView = addClassView;
    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        view.contentView.center = CGPointMake(self.view.width/2, self.view.height/2);
    }];
    self.navigationItem.title = @"作业";
}

- (void)handleVerifyUserWithItem:(YXHomeworkListGroupsItem *)item {
    self.rightButton = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"刷新"] highLightedImage:nil];
    self.actionType = YXClassActionTypeCancelJoining;
    self.classId = item.property.classId;
    self.emptyView.hidden = YES;
    self.alertView = [EEAlertView new];
    self.alertView.hideAlertWhenButtonTapped = NO;
    self.alertView.title = @"你的班级加入申请正在审核中......";
    WEAK_SELF
    [self.alertView addButtonWithTitle:@"查看详情" action:^{
        STRONG_SELF
        [self showClassDetailWithClassId:self.classId];
    }];
    [self.alertView showInView:self.view];
    self.navigationItem.title = item.property.className;
}

- (void)handleHomeworkRequestSuccessWithItem:(YXHomeworkListGroupsItem *)item {
    self.rightButton = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"首页"] highLightedImage:nil];
    self.actionType = YXClassActionTypeExit;
    self.classId = item.property.classId;
    self.navigationItem.title = item.property.className;
    [YXRecordManager addRecordWithType:YXRecordClassType];
}

- (void)handleHomeworkRequestError {
    self.navigationItem.rightBarButtonItems = nil;
    self.rightButton = nil;
    self.classId = nil;
    self.navigationItem.title = @"作业";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self.tableView registerClass:[YXHomeworkSubjectCell class] forCellReuseIdentifier:@"data"];
    [self registerNotifications];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    @weakify(self)
    [self.tableView aspect_hookSelector:@selector(reloadData)
                            withOptions:AspectPositionBefore
                             usingBlock:^(id<AspectInfo> aspectInfo) {
                                 @strongify(self); if (!self) return;
                                 [YXRedManager requestPendingHomeWorkNumber];
                             } error:NULL];
}

- (void)loadView
{
    [super loadView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景01"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.actionType == YXClassActionTypeExit) {//没加入班级的时候不用刷新
        [self firstPageFetch];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Setup UI
- (UIView *)emptyWorkView
{
    if (!_emptyWorkView) {
        _emptyWorkView = [UIView new];
        _emptyWorkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _emptyWorkView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyWorkViewTapped)];
        [_emptyWorkView addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)]];
        [_emptyWorkView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 306;
            make.height.offset = 143;
            make.center.offset = 0;
        }];
        
        UILabel *label = [UILabel new];
        label.text = @"您加入的班级尚未布置作业";
        label.textColor = [UIColor colorWithRGBHex:0x805500];
        [label setShadowColor:[UIColor colorWithRGBHex:0xffff99]];
        label.font = [UIFont boldSystemFontOfSize:17];
        [imageView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.offset = 0;
        }];
        
        EEAlertTitleLabel *refreshLabel = [[EEAlertTitleLabel alloc] init];
        refreshLabel.text = @"点击后刷新";
        [imageView addSubview:refreshLabel];
        [refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-17);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"805500"];
        lineView.alpha = 0.8;
        [imageView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-16);
            make.width.equalTo(refreshLabel.mas_width);
            make.height.mas_equalTo(1);
        }];
    }
    return _emptyWorkView;
}

#pragma mark - Notification
- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(joinClassSuccess)
                   name:YXJoinClassSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(cancelReplyClassSuccess)
                   name:YXCancelReplyClassSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(exitClassSuccess)
                   name:YXExitClassSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(applicationWillEnterForeground)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(submitQuestionSuccess:)
                   name:YXSubmitQuestionSuccessNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions 
- (void)emptyWorkViewTapped {
    [self yx_startLoading];
    [self firstPageFetch];
}

- (void)joinClassSuccess
{
    [self firstPageFetch];
}

- (void)cancelReplyClassSuccess
{
    [self firstPageFetch];
}

- (void)exitClassSuccess
{
    [self clearAndReloadData];
    [self firstPageFetch];
}

- (void)yx_rightButtonPressed:(id)sender
{
    switch (self.actionType) {
        case YXClassActionTypeJoin:
            [self goSearchClass];
            break;
        case YXClassActionTypeCancelJoining:
            [self firstPageFetch];
            break;
        case YXClassActionTypeExit:
            [self showClassDetailWithClassId:self.classId];
            break;
        default:
            break;
    }
}

- (void)applicationWillEnterForeground
{
    //[self firstPageFetch];
}

- (void)submitQuestionSuccess:(NSNotification *)notification
{
    [self firstPageFetch];
}

- (void)goSearchClass
{
    YXSearchClassViewController *vc = [[YXSearchClassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showClassDetailWithClassId:(NSString *)classId
{
    self.rightButton.enabled = NO;
    [self yx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager requestClassDetailWithClassID:classId completeBlock:^(YXSearchClassItem *item, NSError *error) {
        STRONG_SELF
        self.rightButton.enabled = YES;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        YXClassInfoViewController *vc = [[YXClassInfoViewController alloc] init];
        vc.actionType = self.actionType;
        vc.rawData = item.data.firstObject;
        [self.parentViewController presentViewController:[[YXNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }];
}

#pragma mark - mock

- (void)clearAndReloadData
{
    [self.dataArray removeAllObjects];
    YXClassHomeworkFetcher *fetcher = (YXClassHomeworkFetcher *)self.dataFetcher;
    fetcher.totalUnfinish = 0;
    [self.tableView reloadData];
}

- (BOOL)bHasUnfinished {
    YXClassHomeworkFetcher *fetcher = (YXClassHomeworkFetcher *)self.dataFetcher;
    if (fetcher.totalUnfinish == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - 2.0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.dataArray count] * 2 - 1;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        return 2;
    }
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        YXDashLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dash"];
        cell.realWidth = 7;
        cell.dashWidth = 7;
        cell.preferedGapToCellBounds = 50;
        cell.bHasShadow = NO;
        cell.realColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        NSInteger index = indexPath.row/2;
        YXHomeworkSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        YXHomeworkGroupMock *data = [YXHomeworkGroupMock mockWithRealItem:self.dataArray[index]];
        [cell updateWithData:data];
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            YXHomeworkListFetcher *fetcher = [[YXHomeworkListFetcher alloc] init];
            fetcher.gid = ((YXHomeworkListGroupsItem_Data *)self.dataArray[index]).groupId;
            YXHomeworkViewController *vc = [[YXHomeworkViewController alloc] initWithFetcher:fetcher];
            vc.groupInfoData = self.dataArray[index];
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (void)refreshHeaderView {
    if (self.bHasUnfinished) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    
}

@end

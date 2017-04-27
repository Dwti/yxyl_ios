//
//  YXClassHomeworkViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkGroupViewController_Pad.h"
#import "YXHomeworkGroupMock.h"
#import "YXAlertView.h"
#import "YXCommonErrorView.h"

#import "YXClassSearchViewController_Pad.h"
#import "YXHomeworkViewController_Pad.h"
#import "YXHomeworkTodoViewController_Pad.h"
#import "YXClassInfoViewController_Pad.h"
#import "YXNavigationController_Pad.h"
#import "UIViewController+YXPresent.h"

#import "YXClassHomeworkFetcher.h"
#import "YXJoinClassRequest.h"
#import "YXExitClassRequest.h"
#import "YXSubmitQuestionRequest.h"
#import "YXCancelReplyClassRequest.h"

#import "YXUnfinishedHeaderCell.h"
#import "YXDashLineCell.h"
#import "YXRedManager.h"
#import "YXHomeworkSubjectCell.h"

#import "YXRecordManager.h"

@interface YXHomeworkGroupViewController_Pad ()

@property (nonatomic, assign) BOOL shouldReload;
@property (nonatomic, assign) BOOL isViewAppear;
@property (nonatomic, strong) YXAlertView *alertView;
@property (nonatomic, strong) YXSearchClassRequest *searchRequest;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, assign) YXClassActionType actionType;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) YXUnfinishedHeaderCell *unfinishedHeaderCell;
@property (nonatomic, strong) UIView *emptyWorkView;

@end

@implementation YXHomeworkGroupViewController_Pad

#pragma mark- Get
- (UIView *)emptyWorkView
{
    if (!_emptyWorkView) {
        _emptyWorkView = [UIView new];
        _emptyWorkView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _emptyWorkView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)]];
        [_emptyWorkView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset = 305;
            make.height.offset = 150;
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
    }
    return _emptyWorkView;
}

#pragma mark- Masonry
- (void)addMasonry
{
    [self.emptyWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset = 0;
    }];
}

#pragma mark-
- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    YXClassHomeworkFetcher *fetcher = [[YXClassHomeworkFetcher alloc] init];
    @weakify(self);
    fetcher.classJoinBlock = ^(YXHomeworkListGroupsItem *item, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        [self.alertView removeFromSuperview];
        self.emptyWorkView.hidden = YES;
        self.alertView = nil;
        if (error.code == 71) {
            [self clearAndReloadData];
            self.rightButton      = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"添加"] highLightedImage:nil];
            self.actionType       = YXClassActionTypeJoin;
            self.classId          = nil;
            self.errorView.hidden = YES;
            self.alertView =         [YXAlertView addJoinClassWithJoinAction:^{
                @strongify(self);
                [self goSearchClass];
            } help:^{
                @strongify(self);
                id vc                          = [NSClassFromString(@"YXAddClassHelpViewController_Pad") new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [self.alertView showInView:self.view];
            self.navigationItem.title = @"作业";
        } else if (error.code == 72) {
            [self clearAndReloadData];
            self.rightButton = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"刷新"] highLightedImage:nil];
            self.actionType = YXClassActionTypeCancelJoining;
            self.classId = item.property.classId;
            self.errorView.hidden = YES;
            self.alertView = [YXAlertView alertWithMessage:@"你的班级加入申请正在审核中......"];
            self.alertView.keepInSuperview = YES;
            @weakify(self);
            [self.alertView addButtonWithTitle:@"查看详情" action:^{
                @strongify(self);
                [self showClassDetailWithClassId:self.classId];
            }];
            [self.alertView showInView:self.view];
            self.navigationItem.title = item.property.className;
        } else if (!error) {
            self.rightButton          = [self yx_setupRightButtonItemWithTitle:nil image:[UIImage imageNamed:@"首页"] highLightedImage:nil];
            self.actionType           = YXClassActionTypeExit;
            self.classId              = item.property.classId;
            self.errorView.hidden     = YES;
            self.navigationItem.title = item.property.className;
            self.emptyWorkView.hidden = item.data.count;
            [YXRecordManager addRecordWithType:YXRecordClassType];
        } else {
            [self clearAndReloadData];
            self.navigationItem.rightBarButtonItems = nil;
            self.rightButton                        = nil;
            self.classId                            = nil;
            self.errorView.hidden                   = NO;
            self.navigationItem.title               = @"作业";
        }
    };
    self.dataFetcher = fetcher;
    
    self.errorView = [[YXCommonErrorView alloc] init];
    self.errorView.hidden = YES;
    
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self.tableView registerClass:[YXHomeworkSubjectCell class] forCellReuseIdentifier:@"data"];
    [self registerNotifications];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView aspect_hookSelector:@selector(reloadData)
                            withOptions:AspectPositionBefore
                             usingBlock:^(id<AspectInfo> aspectInfo) {
                                 @strongify(self); if (!self) return;
//                                 [self refreshHeaderView];
                                 [YXRedManager requestPendingHomeWorkNumber];
                             } error:NULL];
    [self yx_startLoading];
    [self.view addSubview:self.emptyWorkView];
    [self addMasonry];
}

- (void)loadView
{
    [super loadView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"作业背景"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isViewAppear = YES;
//    if (self.shouldReload || self.actionType == YXClassActionTypeCancelJoining) {
//        [self firstPageFetch];
//        self.shouldReload = NO;
//    }
    [YXRedManager requestPendingHomeWorkNumber];
    if (self.actionType == YXClassActionTypeExit) {//没加入班级的时候不用刷新
        [self firstPageFetch];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isViewAppear = NO;
}

#pragma mark -

- (void)registerNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self//登录成功刷新一下数据
//               selector:@selector(firstPageFetch)
//                   name:YXUserLoginSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(logoutSuccess:)
//                   name:YXUserLogoutSuccessNotification
//                 object:nil];
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

- (void)logoutSuccess:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self clearAndReloadData];
    self.shouldReload = YES;
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
    [self firstPageFetch];
}

- (void)addToGroupAction {
    [self goSearchClass];
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
    [self firstPageFetch];
}

- (void)submitQuestionSuccess:(NSNotification *)notification
{
    [self firstPageFetch];
}

- (void)goSearchClass
{
    YXClassSearchViewController_Pad *vc = [[YXClassSearchViewController_Pad alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showClassDetailWithClassId:(NSString *)classId
{
    self.rightButton.enabled = NO;
    [self.searchRequest stopRequest];
    self.searchRequest = [[YXSearchClassRequest alloc] init];
    self.searchRequest.classId = classId;
    @weakify(self);
    [self yx_startLoading];
    [self.searchRequest startRequestWithRetClass:[YXSearchClassItem class]
                                andCompleteBlock:^(id retItem, NSError *error) {
                                    @strongify(self); if (!self) return;
                                    [self yx_stopLoading];
                                    if (error) {
                                        if (error.code == 2) {
                                            [self yx_showToast:@"不存在的班级号码"];
                                        } else {
                                            [self yx_showToast:error.localizedDescription];
                                        }
                                        self.rightButton.enabled = YES;
                                        return;
                                    }
                                    
                                    YXSearchClassItem *ret = retItem;
                                    if (![ret.data count]) {
                                        [self yx_showToast:@"不存在的班级号码"];
                                        self.rightButton.enabled = YES;
                                        return;
                                    }
                                    
                                    YXClassInfoViewController_Pad *vc = [[YXClassInfoViewController_Pad alloc] init];
                                    vc.actionType = self.actionType;
                                    vc.rawData = ret.data.firstObject;
                                    YXNavigationController_Pad *nav = [[YXNavigationController_Pad alloc] initWithRootViewController:vc];
                                    [self yx_presentViewController:nav completion:^{
                                        self.rightButton.enabled = YES;
                                    }];
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
    
//    NSInteger row = indexPath.row/2;
//    YXHomeworkListGroupsItem_Data *data = self.dataArray[row];
//    if (data.paper.name.length <= 0) {
        // 无最新作业
        return 55;
//    }
    
    // 有最新作业
//    return 92;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        NSInteger index = indexPath.row/2;
        YXHomeworkSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.interval = 75.f;
        YXHomeworkGroupMock *data = [YXHomeworkGroupMock mockWithRealItem:self.dataArray[index]];
        [cell updateWithData:data];
        @weakify(self);
        cell.clickBlock = ^{
            @strongify(self); if (!self) return;
            YXHomeworkViewController_Pad *vc = [[YXHomeworkViewController_Pad alloc] init];
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

//- (void)refreshHeaderView {
//    [self.unfinishedHeaderCell removeFromSuperview];
//    
//    if (self.bHasUnfinished) {
//        self.unfinishedHeaderCell = [[YXUnfinishedHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        YXClassHomeworkFetcher *fetcher = (YXClassHomeworkFetcher *)self.dataFetcher;
//        self.unfinishedHeaderCell.unfinishedCount = fetcher.totalUnfinish;
//        @weakify(self);
//        self.unfinishedHeaderCell.clickBlock = ^{
//            @strongify(self); if (!self) return;
//            YXHomeworkTodoViewController_Pad *vc = [[YXHomeworkTodoViewController_Pad alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        };
//        [self.view addSubview:self.unfinishedHeaderCell];
//        [self.unfinishedHeaderCell mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.mas_equalTo(0);
//            make.height.mas_equalTo(56);
//        }];
//        
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(56, 0, 0, 0));
//        }];
//    } else {
//        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//    }
//}

@end

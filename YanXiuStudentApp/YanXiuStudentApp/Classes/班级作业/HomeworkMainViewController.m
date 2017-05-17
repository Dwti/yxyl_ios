//
//  HomeworkMainViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkMainViewController.h"
#import "HomeworkAddClassView.h"
#import "HomeworkAddClassHelpViewController.h"
#import "ClassHomeworkUtils.h"
#import "ClassInfoViewController.h"
#import "HomeworkClassApplicationVerifingView.h"
#import "HomeworkSubjectCell.h"
#import "HomeworkEmptyView.h"
#import "YXClassHomeworkFetcher.h"
#import "HomeworkClassInfoViewController.h"
#import "YXRecordManager.h"
#import "YXRedManager.h"
#import "HomeworkListViewController.h"

@interface HomeworkMainViewController ()
@property (nonatomic, strong) HomeworkAddClassView *addClassView;
@property (nonatomic, strong) HomeworkClassApplicationVerifingView *verifingView;
@property (nonatomic, assign) HomeworkFetchState state;
@end

@implementation HomeworkMainViewController

- (instancetype)init {
    if (self = [super init]) {
        HomeworkEmptyView *emptyView = [[HomeworkEmptyView alloc]init];
        WEAK_SELF
        [emptyView setRefreshBlock:^{
            STRONG_SELF
            [self.view nyx_startLoading];
            [self firstPageFetch];
        }];
        self.emptyView = emptyView;
        YXClassHomeworkFetcher *fetcher = [[YXClassHomeworkFetcher alloc] init];
        fetcher.classJoinBlock = ^(YXHomeworkListGroupsItem *item, HomeworkFetchState state) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            [self.addClassView removeFromSuperview];
            [self.verifingView removeFromSuperview];
            self.state = state;
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
    self.naviTheme = NavigationBarTheme_Green;
    self.navigationItem.title = @"作业";
    self.navigationItem.rightBarButtonItems = nil;
    self.addClassView = [[HomeworkAddClassView alloc]init];
    WEAK_SELF
    [self.addClassView setNextStepBlock:^{
        STRONG_SELF
        [self gotoSearchClass];
    }];
    [self.addClassView setHelpBlock:^{
        STRONG_SELF
        HomeworkAddClassHelpViewController *vc = [[HomeworkAddClassHelpViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:self.addClassView];
    [self.addClassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)handleVerifyUserWithItem:(YXHomeworkListGroupsItem *)item {
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = item.property.className;
    WEAK_SELF
    [self nyx_setupRightWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 38, 38)] action:^{
        STRONG_SELF
        [self gotoClassDetailWithClassId:item.property.classId];
    }];
    self.verifingView = [[HomeworkClassApplicationVerifingView alloc]init];
    [self.verifingView setRefreshBlock:^{
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [self.view addSubview:self.verifingView];
    [self.verifingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)handleHomeworkRequestSuccessWithItem:(YXHomeworkListGroupsItem *)item {
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = item.property.className;
    WEAK_SELF
    [self nyx_setupRightWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 38, 38)] action:^{
        STRONG_SELF
        [self gotoClassDetailWithClassId:item.property.classId];
    }];
    [YXRecordManager addRecordWithType:YXRecordClassType];
}

- (void)handleHomeworkRequestError {
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.title = @"作业";
}

- (void)gotoSearchClass {
    if (![ClassHomeworkUtils isClassNumberValid:self.addClassView.classNumberString]) {
        [self.view nyx_showToast:@"请输入正确的班级号"];
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [ClassHomeworkDataManager searchClassWithClassID:self.addClassView.classNumberString completeBlock:^(YXSearchClassItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        YXSearchClassItem_Data *data = item.data[0];
        ClassInfoViewController *vc = [[ClassInfoViewController alloc] init];
        vc.rawData = data;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)gotoClassDetailWithClassId:(NSString *)classId {
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager requestClassDetailWithClassID:classId completeBlock:^(YXSearchClassItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        HomeworkClassInfoViewController *vc = [[HomeworkClassInfoViewController alloc] init];
        vc.isVerifying = self.state==HomeworkFetch_NeedVerify;
        vc.rawData = item.data.firstObject;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HomeworkSubjectCell class] forCellReuseIdentifier:@"HomeworkSubjectCell"];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXJoinClassSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXCancelReplyClassSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXExitClassSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [self.tableView aspect_hookSelector:@selector(reloadData)
                            withOptions:AspectPositionBefore
                             usingBlock:^(id<AspectInfo> aspectInfo) {
                                 STRONG_SELF
                                 [YXRedManager requestPendingHomeWorkNumber];
                             } error:NULL];
}

#pragma mark - tableview datasource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkSubjectCell"];
    cell.data = self.dataArray[indexPath.row];
    cell.isLast = indexPath.row==self.dataArray.count-1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXHomeworkListGroupsItem_Data *data = self.dataArray[indexPath.row];
    HomeworkListViewController *vc = [[HomeworkListViewController alloc]initWithData:data];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

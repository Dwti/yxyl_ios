//
//  TextBookVersionViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TextBookVersionViewController.h"
#import "YXCommonErrorView.h"
#import "GetSubjectRequest.h"
#import "ChooseEditionViewController.h"
#import "VolumeListCell.h"

@interface TextBookVersionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) GetSubjectRequestItem *item;
@end

@implementation TextBookVersionViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"教材版本";
    [self registerNotifications];
    [self setupUI];
    [self requestSubjects];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestSubjects];
    }];
}

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(saveEditionInfoSuccess)
                   name:kSubjectSaveEditionInfoSuccessNotification
                 object:nil];
}

- (void)saveEditionInfoSuccess
{
    self.item = [[ExerciseSubjectManager sharedInstance]currentSubjectItem];
    [self.tableView reloadData];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestSubjects
{
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    if (self.item.subjects) {
        [self.tableView reloadData];
        return;
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance] requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        self.item = retItem;
        if (self.item) {
            [self.tableView reloadData];
        } else {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[VolumeListCell class] forCellReuseIdentifier:@"VolumeListCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VolumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolumeListCell"];
    cell.subject = self.item.subjects[indexPath.row];
    cell.shouldShowShadow = indexPath.row==1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self requestEditionsWithSubject:self.item.subjects[indexPath.row]];
}

- (void)requestEditionsWithSubject:(GetSubjectRequestItem_subject *)subject {
    WEAK_SELF
    [self.view nyx_startLoading];
    [[ExerciseSubjectManager sharedInstance]requestEditionsWithSubjectID:subject.subjectID completeBlock:^(GetEditionRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (retItem && retItem.editions.count == 0) {
            if (retItem.status.desc) {
                [self.view nyx_showToast:retItem.status.desc];
            }
            return;
        }
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        ChooseEditionViewController *vc = [[ChooseEditionViewController alloc]init];
        vc.subject = subject;
        vc.type = ChooseEditionFromType_PersonalCenter;
        vc.item = retItem;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end

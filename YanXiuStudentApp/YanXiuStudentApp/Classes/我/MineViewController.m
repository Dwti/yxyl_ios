//
//  MineViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineViewController.h"
#import "MineItemCell.h"
#import "MineTableHeaderView.h"
#import "StageSelectionViewController.h"
#import "MyProfileViewController.h"
#import "YXMistakeSubjectViewController.h"
#import "ExerciseHistorySubjectViewController.h"
#import "FeedbackViewController.h"
#import "SettingsViewController.h"
#import "TextBookVersionViewController.h"
#import "HeadImagePickerOptionView.h"
#import "HeadImageHandler.h"
#import "SimpleAlertView.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineTableHeaderView *headerView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) HeadImageHandler *imageHandler;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.imageHandler = [[HeadImageHandler alloc]init];
    [self setupUI];
    [self setupObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.topViewController != self) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.headerView = [[MineTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 153)];
    self.headerView.name = [YXUserManager sharedManager].userModel.realname;
    self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    if (isEmpty([YXUserManager sharedManager].userModel.passport.loginName)) {
        self.headerView.account = [YXUserManager sharedManager].userModel.passport.mobile;
    }else {
        self.headerView.account = [YXUserManager sharedManager].userModel.passport.loginName;
    }
    WEAK_SELF
    [self.headerView setEnterBlock:^{
        STRONG_SELF
        MyProfileViewController *vc = [[MyProfileViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.headerView setEditBlock:^{
        STRONG_SELF
        [self showImagePickerAlert];
    }];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[MineItemCell class] forCellReuseIdentifier:@"MineItemCell"];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    v.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self.tableView addSubview:v];
}

- (void)showImagePickerAlert {
    HeadImagePickerOptionView *optionView = [[HeadImagePickerOptionView alloc]init];
    WEAK_SELF
    [optionView setAlbumBlock:^{
        STRONG_SELF
        [self.alertView hide];
        [self pickImageFromAlbum];
    }];
    [optionView setCameraBlock:^{
        STRONG_SELF
        [self.alertView hide];
        [self pickImageFromCamera];
    }];
    [optionView setCancelBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    
    self.alertView = [[AlertView alloc]init];
    self.alertView.hideWhenMaskClicked = YES;
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.alertView.contentView = optionView;
    [self.alertView showInView:self.view.window withLayout:^(AlertView *view) {
        view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 235);
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-235, SCREEN_WIDTH, 235);
        } completion:^(BOOL finished) {
            
        }];
    }];
    [self.alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 235);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}

- (void)pickImageFromAlbum {
    WEAK_SELF
    [self.imageHandler pickImageFromAlbumWithCompleteBlock:^(UIImage *image) {
        STRONG_SELF
        [self updateHeadImage:image];
    }];
}

- (void)pickImageFromCamera {
    WEAK_SELF
    [self.imageHandler pickImageFromCameraWithCompleteBlock:^(UIImage *image) {
        STRONG_SELF
        [self updateHeadImage:image];
    }];
}

- (void)updateHeadImage:(UIImage *)image {
    if (!image) {
        return;
    }
    WEAK_SELF
    [self.view nyx_startLoading];
    [[YXUpdateUserInfoHelper instance]updateHeadImageWithImage:image completeBlock:^(YXUploadHeadImgItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateUserInfoSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSNumber *value = [x.userInfo valueForKey:YXUpdateUserInfoTypeKey];
        YXUpdateUserInfoType type = value.integerValue;
        if (type == YXUpdateUserInfoTypeRealname) {
            self.headerView.name = [YXUserManager sharedManager].userModel.realname;
        }else if (type == YXUpdateUserInfoTypeStage) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateHeadImgSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.title = @"我的错题";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"我的错题icon"];
        }else {
            cell.title = @"练习历史";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"练习历史icon"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.title = @"学段";
            cell.subtitle = [YXUserManager sharedManager].userModel.stageName;
            cell.image = [UIImage imageNamed:@"学段icon"];
        }else {
            cell.title = @"教材版本";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"教材版本icon"];
        }
    }else {
        if (indexPath.row == 0) {
            cell.title = @"意见反馈";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"意见反馈icon"];
        }else {
            cell.title = @"设置";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"设置icon"];
        }
    }
    cell.shouldShowShadow = indexPath.row==1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YXMistakeSubjectViewController *vc = [[YXMistakeSubjectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            ExerciseHistorySubjectViewController *vc = [[ExerciseHistorySubjectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            StageSelectionViewController *vc = [[StageSelectionViewController alloc]init];
            vc.currentIndex = [YXMineManager indexWithStageId:[YXUserManager sharedManager].userModel.stageid];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            TextBookVersionViewController *vc = [[TextBookVersionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (indexPath.row == 0) {
            FeedbackViewController *vc = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            SettingsViewController *vc = [[SettingsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        return;
    }
    CGFloat space = ABS(yOffset);
    CGFloat rate = space/80;
    rate = MIN(rate, 1);
    self.headerView.offsetRate = rate;
}

@end

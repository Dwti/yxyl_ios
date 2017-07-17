//
//  MyProfileViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileTableHeaderView.h"
#import "MineItemCell.h"
#import "EditNameViewController.h"
#import "SexSelectionViewController.h"
#import "AreaSelectionViewController.h"
#import "HeadImagePickerOptionView.h"
#import "HeadImageHandler.h"

@interface MyProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyProfileTableHeaderView *headerView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) HeadImageHandler *imageHandler;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"个人资料";
    self.imageHandler = [[HeadImageHandler alloc]init];
    [self setupUI];
    [self setupObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.headerView = [[MyProfileTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155)];
    self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    WEAK_SELF
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
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.alertView.contentView = optionView;
    [self.alertView showInView:self.view.window withLayout:^(AlertView *view) {
        view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 235);
        [UIView animateWithDuration:0.3 animations:^{
            view.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-235, SCREEN_WIDTH, 235);
        } completion:^(BOOL finished) {
            
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
            [self yx_showToast:error.localizedDescription];
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
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else if (type == YXUpdateUserInfoTypeSex) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else if (type == YXUpdateUserInfoTypeSchool) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateHeadImgSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemCell"];
    if (indexPath.row == 0) {
        cell.title = @"姓名";
        cell.subtitle = [YXUserManager sharedManager].userModel.realname;
        cell.image = [UIImage imageNamed:@"姓名icon"];
    }else if (indexPath.row == 1){
        cell.title = @"性别";
        NSInteger index = [YXMineManager indexWithSexId:[YXUserManager sharedManager].userModel.sex];
        cell.subtitle = [YXMineManager sexNames][index];
        cell.image = [UIImage imageNamed:@"性别icon"];
    }else {
        cell.title = @"学校";
        cell.subtitle = [YXUserManager sharedManager].userModel.schoolName;
        cell.image = [UIImage imageNamed:@"学校icon"];
    }
    cell.shouldShowShadow = indexPath.row==2;
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
    if (indexPath.row == 0) {
        EditNameViewController *vc = [[EditNameViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        SexSelectionViewController *vc = [[SexSelectionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        AreaSelectionViewController *vc = [[AreaSelectionViewController alloc]init];
        vc.baseVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

//
//  SettingsViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "MineItemCell.h"
#import "MineActionView.h"

typedef NS_ENUM(NSUInteger, SettingItemType) {
    SettingItem_BindPhone,
    SettingItem_ChangePassword,
    SettingItem_About
};

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSNumber *> *itemArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    if ([YXUserManager sharedManager].isThirdLogin) {
        self.itemArray = @[@(SettingItem_About)];
    } else {
        self.itemArray = @[@(SettingItem_BindPhone),@(SettingItem_ChangePassword),@(SettingItem_About)];
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[MineItemCell class] forCellReuseIdentifier:@"MineItemCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    MineActionView *logoutView = [[MineActionView alloc]init];
    logoutView.title = @"退出登录";
    WEAK_SELF
    [logoutView setActionBlock:^{
        STRONG_SELF
        [[YXUserManager sharedManager] logout];
    }];
    [self.view addSubview:logoutView];
    [logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250*kPhoneWidthRatio, 50));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemCell"];
    SettingItemType type = self.itemArray[indexPath.row].integerValue;
    if (type == SettingItem_BindPhone) {
        cell.image = [UIImage imageNamed:@"绑定手机icon"];
        if (isEmpty([YXUserManager sharedManager].userModel.mobile)) {
            cell.title = @"绑定手机";
            cell.subtitle = nil;
        }else {
            cell.title = @"修改手机";
            cell.subtitle = [[YXUserManager sharedManager].userModel.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }else if (type == SettingItem_ChangePassword) {
        cell.image = [UIImage imageNamed:@"修改密码icon"];
        cell.title = @"修改密码";
        cell.subtitle = nil;
    }else {
        cell.image = [UIImage imageNamed:@"关于icon"];
        cell.title = @"关于";
        cell.subtitle = nil;
    }
    cell.shouldShowShadow = indexPath.row==self.itemArray.count-1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

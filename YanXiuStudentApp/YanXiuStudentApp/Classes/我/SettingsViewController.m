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
#import "BindPhoneViewController.h"
#import "VerifyPhoneViewController.h"
#import "ChangePasswordViewController.h"
#import "AboutViewController.h"
#import "SoundSwitchCell.h"

typedef NS_ENUM(NSUInteger, SettingItemType) {
    SettingItem_BindPhone,
    SettingItem_ChangePassword,
    SettingItem_SoundSwitch,
    SettingItem_About
};

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray <NSNumber *>*> *itemArray;
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
        NSArray *array1 =  @[@(SettingItem_BindPhone),@(SettingItem_ChangePassword),@(SettingItem_SoundSwitch)];
        NSArray *array2 = @[@(SettingItem_About)];
        self.itemArray = @[array1,array2];
        
    }
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[MineItemCell class] forCellReuseIdentifier:@"MineItemCell"];
    [self.tableView registerClass:[SoundSwitchCell class] forCellReuseIdentifier:@"SoundSwitchCell"];
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

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kBindPhoneSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        [self.navigationController popToViewController:self animated:YES];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemCell"];
        SettingItemType type = self.itemArray[indexPath.section][indexPath.row].integerValue;
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
        cell.shouldShowShadow = indexPath.row==self.itemArray[indexPath.section].count-1;
        return cell;
    }else {
        SoundSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundSwitchCell"];
        NSInteger index = [YXMineManager indexWithSoundSwitchState:[YXUserManager sharedManager].userModel.soundSwitchState];
        cell.title = @"音效";
        cell.isOn = index == 0 ? YES : NO;
        WEAK_SELF
        [cell setSwitchActionBlock:^(BOOL isOn) {
            STRONG_SELF
            NSInteger index = isOn == YES ? 0 : 1;
            [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeSoundSwitch param:@{@"soundSwitchState":[YXMineManager soundSwitchStates][index]} completion:^(NSError *error) {
                STRONG_SELF
                if (error) {
                    [self.view nyx_showToast:error.localizedDescription];
                    return;
                }
                [self.tableView reloadData];
            }];
        }];
        cell.shouldShowShadow = indexPath.row==self.itemArray[indexPath.section].count-1;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingItemType type = self.itemArray[indexPath.section][indexPath.row].integerValue;
    if (type == SettingItem_BindPhone) {
        if (isEmpty([YXUserManager sharedManager].userModel.mobile)) {
            BindPhoneViewController *vc = [[BindPhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            VerifyPhoneViewController *vc = [[VerifyPhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (type == SettingItem_ChangePassword) {
        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        AboutViewController *vc = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
@end

//
//  YXSettingViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSettingViewController.h"
#import "YXMineTableViewCell.h"
#import "YXCommonButtonCell.h"
#import "YXAboutViewController.h"
#import "YXModifyPasswordViewController.h"
#import "YXFeedbackViewController.h"
#import "YXWebViewController.h"
#import "BindPhoneViewController.h"
#import "ModifyBindPhoneViewController.h"

@interface YXSettingViewController ()
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *classArray;
@end

@implementation YXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self yx_setupLeftBackBarButtonItem];

    if ([YXUserManager sharedManager].isThirdLogin) {
        self.array = @[@"关于"];
        self.classArray = @[@"YXAboutViewController", @"YXWebViewController"];
    } else {
        self.array = @[@"绑定手机", @"修改密码", @"关于"];
        self.classArray = @[@"BindPhoneViewController", @"YXModifyPasswordViewController", @"YXAboutViewController", @"YXWebViewController"];
    }
    
    [self.tableView registerClass:[YXCommonButtonCell class] forCellReuseIdentifier:kCommonButtonCellIdentifier];
    
    WEAK_SELF;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"bind success" object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self yx_showToast:@"绑定成功"];
        ModifyBindPhoneViewController *vc = [[ModifyBindPhoneViewController alloc] init];
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"rebind success" object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self yx_showToast:@"更换绑定成功"];
        ModifyBindPhoneViewController *vc = [[ModifyBindPhoneViewController alloc] init];
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)logoutAction {
    [[YXUserManager sharedManager] logout];
}

- (UIViewController *)viewControllerWithRow:(NSInteger)row {
    Class class = NSClassFromString(self.classArray[row]);
    UIViewController *vc = nil;
    if ([class isSubclassOfClass:[YXWebViewController class]]) {
        vc = [(YXWebViewController *)[class alloc] initWithUrl:@"http://mobile.hwk.yanxiu.com/privacy_policy.html"];
    } else {
        vc = [[class alloc] init];
    }
    vc.title = self.array[row];
    return vc;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.array.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
        [cell setTitle:self.array[indexPath.row] image:nil];
        cell.showLine = [self showLineAtIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        YXCommonButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommonButtonCellIdentifier];
        [cell setButtonText:@"退出"];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc = [self viewControllerWithRow:indexPath.row];
        
        if (![vc isKindOfClass:[YXAboutViewController class]]) {
            if (indexPath.row == 0) {
                if (!isEmpty([YXUserManager sharedManager].userModel.mobile)) {
                    vc = [[ModifyBindPhoneViewController alloc] init];
                } else {
                    vc = [[BindPhoneViewController alloc] initWithType:BindMobileTypeBind];
                }
            }
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        [self logoutAction];
    }
}

@end

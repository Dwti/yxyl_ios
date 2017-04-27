//
//  ModifyBindPhoneViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/29/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "ModifyBindPhoneViewController.h"
#import "BindPhoneViewController.h"

@interface ModifyBindPhoneViewController ()

@end

@implementation ModifyBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self yx_setupLeftBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    [cell setTitle:@"修改手机" image:nil];
    [cell updateWithAccessoryText:[self encodedMobile]];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BindPhoneViewController *vc = [[BindPhoneViewController alloc] initWithType:BindMobileTypeVerify];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper
- (NSString *)encodedMobile {
    NSString *mobile = [YXUserManager sharedManager].userModel.mobile;
    if (isEmpty(mobile)) {
        return @"";
    }
    return [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];;
}

@end

//
//  YXAboutViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXAboutViewController.h"
#import "YXMineTableViewCell.h"
#import "YXWebViewController.h"

@interface YXAboutViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation YXAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    self.title = @"关于";
    self.array = @[@{@"官方微信：":@"yixueyilian"},
                   @{@"客服电话：":@"400-870-6696"},
                   @{@"QQ群：":@"438863057"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    UIImage *image = [UIImage imageNamed:@"登录_logo"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.text = [NSString stringWithFormat:@"V%@", [YXConfigManager sharedInstance].clientVersion];
    versionLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [headerView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(5);
        make.height.mas_equalTo(25);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSDictionary *info = self.array[indexPath.row];
        NSString *tel = info.allValues[0];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        YXWebViewController *vc = [[YXWebViewController alloc] initWithUrl:@"http://mobile.hwk.yanxiu.com/privacy_policy.html"];
        vc.title = @"隐私政策";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.array.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    if (indexPath.section == 0 && indexPath.row != 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.showLine = [self showLineAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.accessoryViewHidden = YES;
        NSDictionary *info = self.array[indexPath.row];
        [cell setTitle:info.allKeys[0] image:nil];
        [cell updateWithAccessoryText:info.allValues[0]];
    } else {
        cell.accessoryViewHidden = NO;
        [cell setTitle:@"隐私政策" image:nil];
        [cell updateWithAccessoryText:nil];
    }
    return cell;
}

@end

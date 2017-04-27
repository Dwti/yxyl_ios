//
//  YXAboutViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXAboutViewController_Pad.h"

@interface YXAboutViewController_Pad ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation YXAboutViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 445)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.height.mas_equalTo(image.size.height);
        make.width.mas_equalTo(image.size.width);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.backgroundColor = [UIColor whiteColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = YXTextBlackColor;
    versionLabel.text = [NSString stringWithFormat:@"V%@", [YXConfigManager sharedInstance].clientVersion];
    versionLabel.font = [UIFont boldSystemFontOfSize:17.f];
    versionLabel.layer.cornerRadius = 4.f;
    versionLabel.clipsToBounds = YES;
    [headerView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    cell.accessoryViewHidden = YES;
    NSDictionary *info = self.array[indexPath.row];
    [cell setTitle:info.allKeys[0] image:nil];
    [cell updateWithAccessoryText:info.allValues[0]];
    return cell;
}

@end

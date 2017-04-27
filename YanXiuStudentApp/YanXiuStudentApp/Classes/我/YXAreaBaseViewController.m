//
//  YXAreaBaseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXAreaBaseViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@interface YXAreaBaseViewController ()

@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation YXAreaBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage stretchImageNamed:@"搜索列表背景"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.right.mas_equalTo(-34);
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-120);
    }];
    self.bgView = bgView;
    
    [self.tableView removeFromSuperview];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
    [bgView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 6, 12, 6));
    }];
}

- (void)relayoutWithItemCount:(NSInteger)count{
    CGFloat contentHeight = count*45 + 35 + 12;
    CGFloat maxHeight = self.view.bounds.size.height - 64 - 25*2;
    CGFloat height = MIN(contentHeight, maxHeight);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(34);
        make.right.mas_equalTo(-34);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

@end

//
//  YXAreaBaseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXAreaBaseViewController_Pad.h"

@interface YXAreaBaseViewController_Pad ()

@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation YXAreaBaseViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        make.left.mas_equalTo(75);
        make.right.mas_equalTo(-75);
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-120);
    }];
    self.bgView = bgView;
    
    [self.tableView removeFromSuperview];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [bgView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 6, 12, 6));
    }];
}

- (void)relayoutWithItemCount:(NSInteger)count{
    CGFloat contentHeight = count*45 + 35 + 12*2;
    CGFloat maxHeight = self.view.bounds.size.height - 64 - 25*2;
    CGFloat height = MIN(contentHeight, maxHeight);
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.right.mas_equalTo(-75);
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

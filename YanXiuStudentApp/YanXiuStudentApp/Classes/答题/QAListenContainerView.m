//
//  QAListenContainerView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAListenContainerView.h"
#import "QAListenComplexCell.h"


@interface QAListenContainerView () <
UITableViewDataSource,
UITableViewDelegate,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) CGFloat yueCellHeight;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) QAQuestion *qaData;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;

@end


@implementation QAListenContainerView

- (instancetype)initWithData:(QAQuestion *)data {
    if (self = [super init]) {
        self.qaData = data;
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.yueCellHeight = [QAListenComplexCell heightForString:self.qaData.stem] + 51;

    self.borderView = [[UIView alloc]init];
    self.borderView.backgroundColor = [UIColor clearColor];
    self.borderView.backgroundColor = [UIColor whiteColor];
    self.borderView.clipsToBounds = YES;
    self.borderView.layer.cornerRadius = 10;
    self.borderView.layer.borderWidth = 2;
    self.borderView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = YES;
    [self.tableView registerClass:[QAListenComplexCell class] forCellReuseIdentifier:@"QAListenComplexCell"];
}

- (void)setupLayout {
    [self addSubview:self.borderView];
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20).priorityHigh();
        make.bottom.mas_equalTo(-9).priorityHigh();
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.top.mas_equalTo(22+15);
        make.bottom.mas_equalTo(-16);
    }];
}

#pragma mark- tableView datasource 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.yueCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.yueCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAListenComplexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAListenComplexCell"];
    self.cell = cell;
    cell.delegate = self;
    cell.item = self.qaData;
    return cell;
}

- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = self.yueCellHeight;
    CGFloat nh = ceilf(height);
    if (h != nh) {
        self.yueCellHeight = nh;
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
    }
}


@end

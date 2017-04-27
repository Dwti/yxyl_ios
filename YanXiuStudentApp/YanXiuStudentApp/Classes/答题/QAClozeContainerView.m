//
//  QAClozeContainerView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAClozeContainerView.h"
#import "YXQAUtils.h"
#import "QAQuestionUtil.h"


@interface QAClozeContainerView () <
UITableViewDataSource,
UITableViewDelegate,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) CGFloat yueCellHeight;
@property (nonatomic, strong) NSArray *indexArray;
@property (nonatomic, strong) NSMutableArray *myAnswerArray;
@property (nonatomic, strong) NSMutableArray *imagePositionArray;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *qImageView;
@property (nonatomic, strong) UIImageView *stemBgView;
@property (nonatomic, strong) QAQuestion *qaData;

@end


@implementation QAClozeContainerView

- (instancetype)initWithData:(QAQuestion *)data {
    if (self = [super init]) {
        self.qaData = data;
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.yueCellHeight = [QAClozeQuestionCell heightForString:self.qaData.stem];

    self.qImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q"]];
    
    self.stemBgView = [[UIImageView alloc]initWithImage:[YXQAUtils stemBgImage]];
    self.stemBgView.clipsToBounds = YES;
    self.stemBgView.userInteractionEnabled = YES;
 
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAClozeQuestionCell class] forCellReuseIdentifier:@"QAClozeQuestionCell"];
}

- (void)setupLayout {
    [self addSubview:self.qImageView];
    [self.qImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(27);
        make.size.mas_equalTo(CGSizeMake(28, 30));
    }];
    
    [self addSubview:self.stemBgView];
    [self.stemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(53);
        make.top.mas_equalTo(20).priorityHigh();
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.mas_bottom).priorityHigh().offset = -9;
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-22);
        make.top.mas_equalTo(22);
        make.bottom.mas_equalTo(-16);
    }];
}

- (NSString *)itemPositon:(QAQuestion *)item {
    return [[item.position.indexDetailString componentsSeparatedByString:@"/"] objectAtIndex:0];
}

#pragma mark- UITableView
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
    QAClozeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAClozeQuestionCell"];
    cell.isAnalysis = self.isAnalysis;
    cell.delegate = self;
    cell.selectItemDelegate = self.delegate;
    cell.qaData = self.qaData;
    cell.currentIndex = self.currentIndex;
    self.clozeCell = cell;
    
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

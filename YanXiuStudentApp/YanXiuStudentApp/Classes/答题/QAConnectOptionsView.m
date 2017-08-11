//
//  QAConnectOptionsView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectOptionsView.h"
#import "QAConnectContentCell.h"

@interface QAConnectOptionsView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, strong) NSIndexPath *oldIndexPath;
@property (nonatomic, copy) SelectedOptionCellActionBlock selectedActionBlock;

@end

@implementation QAConnectOptionsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"e3e6e4"];;
    
    UIImageView *topShadowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"连线题灰底上阴影"]];
    [self addSubview:topShadowView];
    [topShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20.f);
    }];
    
    UIImageView *bottomShadowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"连线题灰底下阴影"]];
    [self addSubview:bottomShadowView];
    [bottomShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20.f);
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.tableView registerClass:[QAConnectContentCell class] forCellReuseIdentifier:@"QAConnectContentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    QAConnectContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAConnectContentCell"];
    QAConnectContentCell *cell = [[QAConnectContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.optionInfo = self.optionInfoArray[indexPath.row];
    WEAK_SELF
    [cell setHeightChangeBlock:^(CGFloat height) {
        STRONG_SELF
        CGFloat cellHeight = self.optionInfoArray[indexPath.row].size.height;
        CGFloat newCellHeight = ceilf(height);
        if (cellHeight < newCellHeight) {
            CGSize size = self.optionInfoArray[indexPath.row].size;
            size.height = newCellHeight;
            self.optionInfoArray[indexPath.row].size = size;
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.optionInfoArray[indexPath.row].size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.oldIndexPath) {
        BOOL isEqual = ([self.oldIndexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
        if (isEqual) {
            return;
        }
    }
    self.oldIndexPath = indexPath;
    
    self.optionInfoArray[indexPath.row].snapshotImage = [QAConnectOptionInfo imageFromView:[tableView cellForRowAtIndexPath:indexPath]];
    self.optionInfoArray[indexPath.row].frame = [self.tableView cellForRowAtIndexPath:indexPath].frame;
    
    BLOCK_EXEC(self.selectedActionBlock,self.optionInfoArray[indexPath.row]);
}

-(void)setSelectedOptionCellActionBlock:(SelectedOptionCellActionBlock)block {
    self.selectedActionBlock = block;
}

- (void)reloadData {
    self.oldIndexPath = nil;
    [self.tableView reloadData];
}

@end

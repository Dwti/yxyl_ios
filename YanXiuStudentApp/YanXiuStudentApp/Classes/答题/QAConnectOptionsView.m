//
//  QAConnectOptionsView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectOptionsView.h"
#import "QAConnectContentCell.h"

@interface QAConnectOptionsView ()<UITableViewDataSource,UITableViewDelegate,YXHtmlCellHeightDelegate>
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
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"e3e6e4"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[QAConnectContentCell class] forCellReuseIdentifier:@"QAConnectContentCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    QAConnectContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAConnectContentCell"];
    QAConnectContentCell *cell = [[QAConnectContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.maxContentWidth = [QAConnectOptionsView maxContentWidth];
    cell.content = self.optionsArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeightArray[indexPath.row] floatValue];
}

- (NSMutableArray *)cellHeightArray {
    if (_cellHeightArray == nil) {
        _cellHeightArray = [NSMutableArray array];
        [self.optionsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_cellHeightArray addObject:@([QAConnectContentCell heightForString:obj width:[QAConnectOptionsView maxContentWidth]])];
        }];
    }
    return _cellHeightArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.oldIndexPath) {
        BOOL isEqual = ([self.oldIndexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
        if (isEqual) {
            return;
        }
    }
    self.oldIndexPath = indexPath;
    BLOCK_EXEC(self.selectedActionBlock,self.optionsArray[indexPath.row]);
}
#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    CGFloat cellHeight = [self.cellHeightArray[indexPath.row] floatValue];
    CGFloat newCellHeight = ceilf(height);
    if (cellHeight < newCellHeight) {
        [self.cellHeightArray replaceObjectAtIndex:indexPath.row withObject:@(newCellHeight)];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

+ (CGFloat)maxContentWidth {
    return (SCREEN_WIDTH - 45)/2 - 40 - 30;
}
-(void)setSelectedOptionCellActionBlock:(SelectedOptionCellActionBlock)block {
    self.selectedActionBlock = block;
}

- (void)reloadData {
    self.oldIndexPath = nil;
    [self updateCellHeight];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}

- (void)updateCellHeight {
    [self.cellHeightArray removeAllObjects];
    [self.optionsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.cellHeightArray addObject:@([QAConnectContentCell heightForString:obj width:[QAConnectOptionsView maxContentWidth]])];
    }];
}
@end

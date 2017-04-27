//
//  YXQASubjectiveView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASubjectiveView_Pad.h"
#import "YXQATitleCell_Pad.h"
#import "YXQAQuestionCell_Pad.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@implementation YXQASubjectiveView_Pad{
    BOOL _bLayoutDone;
    NSMutableArray *_myAnswerArray;
    NSDate *beginDate;
    
}

- (void)startLoading {
    if (!isEmpty(self.data.myAnswers)) {
        _myAnswerArray = [NSMutableArray arrayWithArray:self.data.myAnswers];
    } else {
        _myAnswerArray = [NSMutableArray array];
    }
    beginDate = [NSDate date];
}

- (void)cancelLoading {
    if (_addPhotoCell) {
        self.data.myAnswers = [NSMutableArray arrayWithArray:[_addPhotoCell getPhotoArray]];
    }
    
    if (beginDate) {
        NSTimeInterval time = [[NSDate date]timeIntervalSinceDate:beginDate];
        self.data.answerDuration += time;
        beginDate = nil;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_bLayoutDone) {
        [self _setupUI];
    }
    _bLayoutDone = YES;
    
    [self layoutIfNeeded];
}

- (CGFloat)photoCellheight
{
    YXQAAddPhotoCell_Pad * cell = [[YXQAAddPhotoCell_Pad alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell reloadViewWithArray:_myAnswerArray addEnable:YES];
    return [cell height];
}

- (void)_setupUI {
    _heightArray = [NSMutableArray array];
    if (self.bShowTitleState) {
        YXQATitleCell_Pad *titleCell = [[YXQATitleCell_Pad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        titleCell.item = self.data;
        titleCell.title = self.title;
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:titleCell];
        [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.height.mas_equalTo(35);
        }];
    }
    
    [_heightArray addObject:@([YXQAQuestionCell_Pad heightForString:self.data.stem dashHidden:NO])];
    [_heightArray addObject:@([self photoCellheight])];
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self addSubview:self.tableView];
    CGFloat top = self.bShowTitleState? 35:0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, 0, 0));
    }];
    
    [self.tableView registerClass:[YXQAQuestionCell_Pad class] forCellReuseIdentifier:@"YXQAQuestionCell_Pad"];
    [self.tableView registerClass:[YXQAAddPhotoCell_Pad class] forCellReuseIdentifier:@"YXQAAddPhotoCell_Pad"];
    
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_heightArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        YXQAQuestionCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell_Pad"];
        cell.delegate = self;
        cell.item = self.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    if (_addPhotoCell) {
        return _addPhotoCell;
    }else{
        YXQAAddPhotoCell_Pad * cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAAddPhotoCell_Pad"];
        [cell reloadViewWithArray:_myAnswerArray addEnable:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        _addPhotoCell = cell;
        return cell;
    }
}

#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    
    if (!ip) {
        return;
    }
    
    CGFloat h = [_heightArray[ip.row] floatValue];
    CGFloat nh = ceilf(height);
    if (h != nh) {
        [_heightArray replaceObjectAtIndex:ip.row withObject:@(nh)];
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    }
}

#pragma mark YXQASubjectiveAddPhotoDelegate

- (void)photoViewHeightChanged:(CGFloat)height{
    CGFloat h = [_heightArray[1] floatValue];
    CGFloat nh = ceilf(height);
    if (h != nh) {
        [_heightArray replaceObjectAtIndex:1 withObject:@(nh)];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    }
}

- (void)addPhotoWithViewModel:(YXAlbumViewModel *)viewModel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotoWithViewModel:)]) {
        [self.delegate addPhotoWithViewModel:viewModel];
    }
}

- (void)photoClickedWithModel:(YXAlbumViewModel *)viewModel index:(NSInteger)index canDelete:(BOOL)canDelete{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoClickedWithModel:index:canDelete:)]) {
        [self.delegate photoClickedWithModel:viewModel index:index canDelete:canDelete];
    }
}



@end

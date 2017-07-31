//
//  YXVolumnChooseView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseVolumnView.h"
#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

@interface YXChooseVolumnView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@end

@implementation YXChooseVolumnView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)updateWithDatas:(NSArray *)dataArray selectedIndex:(NSInteger)index {
    self.dataArray = dataArray;
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.lastSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)_setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.clipsToBounds = YES;
    
    self.chooseVolumnButton = [[YXChooseVolumnButton alloc] init];
    self.chooseVolumnButton.bExpand = YES;
    [self addSubview:self.chooseVolumnButton];
    [self.chooseVolumnButton addTarget:self action:@selector(chooseVolumnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 6;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(120);
        make.size.mas_equalTo(CGSizeMake(135, 305));
    }];
    
    UIImageView *triangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹窗三角"]];
    [self addSubview:triangleImageView];
    [triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tableView.mas_top);
        make.centerX.mas_equalTo(self.mas_right).offset(-37);
        make.size.mas_equalTo(CGSizeMake(19, 8));
    }];
    
    [self.tableView registerClass:[YXExerciseChooseChapterKnp_ChooseVolumeCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)chooseVolumnAction:(YXChooseVolumnButton *)sender {
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return 1;
    } else {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 105, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"81d40d"];
        [cell.contentView addSubview:lineView];
        return cell;
    } else {
        GetEditionRequestItem_edition_volume *volume = self.dataArray[indexPath.row/2];
        YXExerciseChooseChapterKnp_ChooseVolumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = volume.name;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selected = self.lastSelectedIndexPath.row == 0;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.lastSelectedIndexPath isEqual:indexPath]) {
        return;
    }
    [[tableView cellForRowAtIndexPath:self.lastSelectedIndexPath] setSelected:NO];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    self.lastSelectedIndexPath = indexPath;
    if (self.chooseBlock) {
        self.chooseBlock(indexPath.row/2);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

@end

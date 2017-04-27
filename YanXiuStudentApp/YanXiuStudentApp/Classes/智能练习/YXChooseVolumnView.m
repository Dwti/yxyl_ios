//
//  YXVolumnChooseView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseVolumnView.h"
#import "YXDashLineCell.h"
#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

@interface YXChooseVolumnView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
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
}

- (void)_setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"007373"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 5, 0));
    }];
    
    [self.tableView registerClass:[YXExerciseChooseChapterKnp_ChooseVolumeCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return 2;
    } else {
        return 45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count] * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        YXDashLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dash"];
        cell.realWidth = 4;
        cell.dashWidth = 3;
        cell.preferedGapToCellBounds = 0;
        cell.bHasShadow = YES;
        cell.realColor = [UIColor colorWithHexString:@"006b6b"];
        cell.shadowColor = [UIColor colorWithHexString:@"009494"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        GetEditionRequestItem_edition_volume *volume = self.dataArray[indexPath.row/2];
        YXExerciseChooseChapterKnp_ChooseVolumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.textLabel.text = volume.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"ffdb4d"];
        cell.textLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
        cell.textLabel.layer.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.layer.shadowOpacity = 1;
        cell.textLabel.layer.shadowRadius = 0;
        cell.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"007878"];
        cell.selectedBackgroundView = bgView;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

//
//  YXHistoryTableView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/10/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHistoryTableView.h"

static NSString *tableViewCell = @"tableViewCell";

@interface YXHistoryTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation YXHistoryTableView

#pragma mark- Get
- (NSArray *)datas
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"counts"];
    NSMutableArray *array = [NSMutableArray new];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:@[key, obj]];
    }];
    return array;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell];
    cell.textLabel.text = self.datas[indexPath.row][0];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.datas.count;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark-
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCell];
    }
    return self;
}

@end

//
//  YXStageViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXStageViewController.h"
#import "YXMineSelectCell.h"
#import "YXMineManager.h"
#import "UIView+YXScale.h"
#import "StagePromptView.h"

@interface YXStageViewController ()
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) StagePromptView *promptView;
@end

@implementation YXStageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择学段";
    [self yx_setupLeftBackBarButtonItem];
    
    if (self.stageid) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow: [YXMineManager indexWithStageId:self.stageid] inSection:0];
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [YXMineManager stageNames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineSelectCellIdentifier];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    [cell setTitle:[YXMineManager stageNames][indexPath.row] image:nil];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath == indexPath || self.isRegisterAccount) {
        self.selectedIndexPath = indexPath;
        self.selectBlock([YXMineManager stageIds][self.selectedIndexPath.row], [YXMineManager stageNames][self.selectedIndexPath.row]);
        [self yx_leftBackButtonPressed:nil];
    } else {
        [self showAlertViewWithIndex:indexPath.row];
    }
    
    return self.selectedIndexPath;
}

#pragma mark - AlertView

- (void)showAlertViewWithIndex:(NSInteger)index {
    self.alertView = [[EEAlertView alloc] init];
  
    self.promptView = [[StagePromptView alloc] init];
    
    WEAK_SELF
    [self.promptView setEditAction:^{
        STRONG_SELF
        self.selectedIndexPath = [[NSIndexPath alloc] initWithIndex:index];
        
        if (self.selectBlock) {
            self.selectBlock([YXMineManager stageIds][index], [YXMineManager stageNames][index]);
            [self yx_leftBackButtonPressed:nil];
        }
    }];
    
    [self.promptView setCancelAction:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    
    self.alertView.contentView = self.promptView;
    [self.alertView showInView:self.view withLayout:^(AlertView *view) {
        [self.alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306);
            make.center.mas_equalTo(0);
        }];
    }];
}


@end

//
//  YXStageChooseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXStageChooseViewController_Pad.h"
#import "UIView+YXScale.h"
#import "YXMineManager.h"
#import "YXEditClassGradeAlertView.h"

@interface YXStageChooseViewController_Pad ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIView *customerView;

@end

@implementation YXStageChooseViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择学段";
    
    if (self.stageid) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[YXMineManager indexWithStageId:self.stageid] inSection:0];
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXEditClassGradeAlertView  *alertView = [YXEditClassGradeAlertView new];
    @weakify(self)
    [alertView setEditBlock:^(){
        @strongify(self)
        self.selectedIndexPath = indexPath;
        if (self.selectBlock) {
            self.selectBlock([YXMineManager stageIds][self.selectedIndexPath.row], [YXMineManager stageNames][self.selectedIndexPath.row]);
            [self yx_leftBackButtonPressed:nil];
        }
    }];
    [alertView showInView:self.view];
    return self.selectedIndexPath;
}

@end

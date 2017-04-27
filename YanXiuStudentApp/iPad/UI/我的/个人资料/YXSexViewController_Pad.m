//
//  YXSexViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSexViewController_Pad.h"
#import "YXMineManager.h"
#import "UIColor+YXColor.h"

@interface YXSexViewController_Pad ()

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *images;

@end

@implementation YXSexViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"性别";
    [self yx_setupLeftBackBarButtonItem];
    
    self.colors = @[[UIColor yx_colorWithHexString:@"007373"], [UIColor yx_colorWithHexString:@"b3476b"]];
    self.images = @[[UIImage imageNamed:@"男"], [UIImage imageNamed:@"女"]];
    
    NSInteger index = [YXMineManager indexWithSexId:[YXUserManager sharedManager].userModel.sex];
    if (index != NSNotFound) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [YXMineManager sexNames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineSelectCellIdentifier];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    NSString *sex = [YXMineManager sexNames][indexPath.row];
    [cell setTitle:sex image:self.images[indexPath.row]];
    cell.textLabel.textColor = self.colors[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock([YXMineManager sexIds][indexPath.row]);
    }
    [self yx_leftBackButtonPressed:nil];
}

@end

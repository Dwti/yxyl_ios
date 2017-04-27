//
//  YXQuestionTypeSelectionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionTypeSelectionViewController.h"
#import "YXQuestionTemplateTypeMapper.h"

@interface YXQuestionTypeSelectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *typeArray;
@end

@implementation YXQuestionTypeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *types = [[YXQuestionTemplateTypeMapper questionTemplateTypeMapDictionary]valueForKey:self.question.qTemplate];
    self.typeArray = [types componentsSeparatedByString:@","];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    NSString *typeID = self.typeArray[indexPath.row];
    NSString *typeString = [[YXQuestionTemplateTypeMapper questionTypeDictionary]valueForKey:typeID];
    cell.textLabel.text = typeString;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *typeID = self.typeArray[indexPath.row];
    self.question.type_id = typeID;
    [self.navigationController popViewControllerAnimated:YES];
}

@end

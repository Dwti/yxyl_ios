//
//  SchoolSearchViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SchoolSearchViewController.h"
#import "SchoolSearchBarView.h"
#import "SchoolSearchAreaView.h"
#import "SchoolSearchResultCell.h"

@interface SchoolSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SchoolSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"选择学校";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupObservers];
    [self searchSchoolWithKeyword:self.currentDistrict.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    SchoolSearchBarView *searchView = [[SchoolSearchBarView alloc]init];
    WEAK_SELF
    [searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
        [self searchSchoolWithKeyword:text];
    }];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15*kPhoneWidthRatio);
        make.right.mas_equalTo(-15*kPhoneWidthRatio);
        make.height.mas_equalTo(50);
    }];
    
    SchoolSearchAreaView *areaView = [[SchoolSearchAreaView alloc]initWithProvince:self.currentProvince.name city:self.currentCity.name district:self.currentDistrict.name];
    [self.view addSubview:areaView];
    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchView.mas_left);
        make.right.mas_equalTo(searchView.mas_right);
        make.top.mas_equalTo(searchView.mas_bottom).mas_offset(13);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[SchoolSearchResultCell class] forCellReuseIdentifier:@"SchoolSearchResultCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(areaView.mas_bottom).mas_offset(13);
    }];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

- (void)searchSchoolWithKeyword:(NSString *)keyword {
    NSString *key = isEmpty(keyword)? self.currentDistrict.name:keyword;
    DDLogWarn(@"search with key: %@",key);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolSearchResultCell"];
    cell.title = @"fhifoegre";
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 17;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSchool *school = [[YXSchool alloc]init];
    school.name = @"野鸡大学";
    BLOCK_EXEC(self.schoolSearchBlock,school);
    [self.navigationController popToViewController:self.baseVC animated:YES];
}

@end

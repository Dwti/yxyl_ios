//
//  YXSchoolSearchViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSchoolSearchViewController_Pad.h"
#import "YXSchoolSearchRequest.h"
#import "UIColor+YXColor.h"
#import "YXAreaSeperatorView.h"
#import "YXSchoolSearchCell.h"
#import "YXSchoolSearchHeaderView.h"
#import "YXCommonLabel.h"

@interface YXSchoolSearchViewController_Pad ()<UISearchBarDelegate, UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) YXSchoolSearchRequest *request;
@property (nonatomic, strong) YXSchoolSearchItem *item;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *searchResultView;

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *inputBgView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) YXAreaSeperatorView *sepView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) YXCommonLabel *tipLabel;
@property (nonatomic, strong) UIImageView *searchImageView;

@end

@implementation YXSchoolSearchViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"学校名称";
    [self setupHeaderView];
    [self setupResultView];
    [self setupConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.request stopRequest];
}

- (void)setupHeaderView
{
    UIImage *bgImage = [UIImage imageNamed:@"搜索按钮背景"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    self.bgView = [[UIImageView alloc]initWithImage:bgImage];
    self.bgView.userInteractionEnabled = YES;
    [self.view addSubview:self.bgView];

    
    UIImage *inputBgImage = [UIImage imageNamed:@"输入框背景"];
    inputBgImage = [inputBgImage stretchableImageWithLeftCapWidth:inputBgImage.size.width/2 topCapHeight:inputBgImage.size.height/2];
    
    self.inputBgView = [[UIImageView alloc]initWithImage:inputBgImage];
    self.inputBgView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.inputBgView];
  
    
    self.addButton = [[UIButton alloc] init];
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.addButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.addButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.addButton.titleLabel.layer.shadowRadius = 0;
    self.addButton.titleLabel.layer.shadowOpacity = 1;
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.addButton];
  
    
    self.sepView = [[YXAreaSeperatorView alloc]init];
    self.sepView.layer.shadowColor = [UIColor colorWithHexString:@"ffeb66"].CGColor;
    self.sepView.layer.shadowOffset = CGSizeMake(0, 1);
    self.sepView.layer.shadowRadius = 0;
    self.sepView.layer.shadowOpacity = 1;
    [self.bgView addSubview:self.sepView];

    
    self.tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips-icon-yellow"]];
    [self.bgView addSubview:self.tipImageView];
    
    YXCommonLabel *tipLabel = [[YXCommonLabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"没有找到？请输入学校名称添加 ^_^";
    [self.bgView addSubview:tipLabel];

    
    self.searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的学校-放大镜"]];
    [self.inputBgView addSubview:self.searchImageView];

    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = [UIFont boldSystemFontOfSize:17];
    self.textField.placeholder = @"请输入学校名称";
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.layer.shadowOffset = CGSizeMake(0, 1);
    self.textField.layer.shadowRadius = 0;
    self.textField.layer.shadowOpacity = 1;
    self.textField.layer.shadowColor = [UIColor colorWithHexString:@"bd8e00"].CGColor;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.inputBgView addSubview:self.textField];
}

- (void)setupConstraints {
    if (self.isRegisteringAccount) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(75);
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(-75);
            make.height.mas_equalTo(60);
        }];
        
        [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(36);
        }];
        
        self.addButton.hidden = YES;
        self.sepView.hidden = YES;
        self.tipImageView.hidden = YES;
        self.tipLabel.hidden = YES;
        
        [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchImageView.mas_right).mas_offset(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
        
    } else {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(75);
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(-75);
            make.height.mas_equalTo(96);
        }];
        
        [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-75);
            make.height.mas_equalTo(36);
        }];
        
        self.addButton.hidden = NO;
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.mas_equalTo(self.inputBgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(51, 36));
        }];
        
        self.sepView.hidden = NO;
        [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.right.mas_equalTo(-6);
            make.top.mas_equalTo(self.inputBgView.mas_bottom).mas_offset(6);
            make.height.mas_equalTo(1);
        }];
        
        self.tipImageView.hidden = NO;
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.mas_equalTo(self.tipLabel.mas_centerY);
        }];
        
        self.tipLabel.hidden = NO;
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipImageView.mas_right).mas_offset(10);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.sepView.mas_bottom);
            make.bottom.mas_equalTo(-8);
        }];
        
        [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchImageView.mas_right).mas_offset(10);
            make.right.mas_equalTo(-10);
            make.top.bottom.mas_equalTo(0);
        }];
    }
}

- (void)setupResultView{
    self.searchResultView = [[UIView alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"搜索列表背景"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
    bgView.userInteractionEnabled = YES;
    [self.searchResultView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tableView removeFromSuperview];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [bgView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 6, 12, 6));
    }];
}

- (void)startSchoolSearch:(NSString *)searchText
{
    searchText = [searchText yx_stringByTrimmingCharacters];
    if (![searchText yx_isValidString]) {
        self.item.data = nil;
        [self.searchResultView removeFromSuperview];
        //        [self.tableView reloadData];
        return;
    }
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXSchoolSearchRequest alloc] init];
    self.request.school = searchText;
    if (self.areaId) {
        self.request.regionId = self.areaId;
    }
    @weakify(self);
    //    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXSchoolSearchItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        //        [self yx_stopLoading];
        self.item = retItem;
        if (self.item.data.count == 0) {
            [self.searchResultView removeFromSuperview];
        }else{
            [self.view addSubview:self.searchResultView];
            [self relayoutResultView];
            [self.tableView reloadData];
        }
    }];
}

- (void)relayoutResultView{
    CGFloat maxHeight = self.view.frame.size.height-25-96-15-25;
    CGFloat contentHeight = self.item.data.count*45+35+12+12;
    CGFloat height = MIN(maxHeight, contentHeight);
    [self.searchResultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.top.mas_equalTo(25+96+15);
        make.right.mas_equalTo(-75);
        make.height.mas_equalTo(height);
    }];
}

- (void)addAction:(id)sender
{
    NSString *schoolName = [self.textField.text yx_stringByTrimmingCharacters];
    if ([schoolName yx_isValidString]) {
        NSError *error = nil;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:schoolName forKey:@"name"];
        YXSchool *school = [[YXSchool alloc] initWithDictionary:dict error:&error];
        [self selectedSchool:school];
    }
}

- (void)selectedSchool:(YXSchool *)school
{
    if (self.selectedSchoolBlock) {
        self.selectedSchoolBlock(school);
    }
    [self yx_leftBackButtonPressed:nil];
}
- (void)textDidChange:(UITextField *)textField{
    [self startSchoolSearch:textField.text];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self startSchoolSearch:textField.text];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"kUITableViewCell";
    YXSchoolSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXSchoolSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = ((YXSchool *)self.item.data[indexPath.row]).name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedSchool:self.item.data[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *identifier = @"YXSchoolSearchHeaderView";
    YXSchoolSearchHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!v) {
        v = [[YXSchoolSearchHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return v;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
}

@end



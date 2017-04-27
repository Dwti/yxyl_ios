//
//  YXQuestionDetailViewControllerBase.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQuestionDetailViewControllerBase.h"
#import "YXQuestionTemplateTypeMapper.h"
#import "YXQuestionTypeSelectionViewController.h"

@interface YXQuestionDetailViewControllerBase ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation YXQuestionDetailViewControllerBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self setupUI];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.typeButton setTitle:[[YXQuestionTemplateTypeMapper questionTypeDictionary] valueForKey:self.question.type_id] forState:UIControlStateNormal];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.containerView = [[UIView alloc]init];
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-64);
    }];
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.numberOfLines = 0;
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.text = @"题型:";
    [self.containerView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(10);
    }];
    self.typeButton = [[UIButton alloc]init];
    [self.typeButton setTitle:[[YXQuestionTemplateTypeMapper questionTypeDictionary] valueForKey:self.question.type_id] forState:UIControlStateNormal];
    [self.typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.typeButton.layer.cornerRadius = 3;
    self.typeButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.typeButton.layer.borderWidth = 1;
    [self.typeButton addTarget:self action:@selector(typeSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.typeButton];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    
    self.identifierLabel = [[UILabel alloc]init];
    self.identifierLabel.text = @"题目标识符:";
    [self.containerView addSubview:self.identifierLabel];
    [self.identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(20);
    }];
    self.identifierField = [[UITextField alloc]init];
    self.identifierField.borderStyle = UITextBorderStyleRoundedRect;
    self.identifierField.placeholder = @"如果需要请输入";
    self.identifierField.text = self.question.identifierForTest;
    self.identifierField.returnKeyType = UIReturnKeyDone;
    self.identifierField.delegate = self;
    [self.containerView addSubview:self.identifierField];
    [self.identifierField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.identifierLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.identifierLabel.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setupObservers{
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        CGFloat naviHeight = self.navigationController.navigationBarHidden? 0:64;
        CGFloat tabBarHeight = [UIScreen mainScreen].bounds.size.height - naviHeight - self.view.bounds.size.height;
        CGFloat bottom = [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y-tabBarHeight;
        bottom = MAX(bottom, 0);
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, bottom, 0));
            }];
            [self.scrollView layoutIfNeeded];
        }];
    }];
}

- (void)backAction{
    [self saveData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveData{
    self.question.identifierForTest = self.identifierField.text;
}

- (void)typeSelectAction{
    YXQuestionTypeSelectionViewController *vc = [[YXQuestionTypeSelectionViewController alloc]init];
    vc.question = self.question;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end

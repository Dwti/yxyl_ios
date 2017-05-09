//
//  CompletePersonalInfoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "CompletePersonalInfoViewController.h"
#import "PersonalInfoSelectionItemView.h"
#import "ClassInfoItemView.h"
#import "LoginActionView.h"
#import "AreaSelectionViewController.h"
#import "StageSelectionViewController.h"

@interface CompletePersonalInfoViewController ()
@property (nonatomic, strong) ClassInfoItemView *nameView;
@property (nonatomic, strong) PersonalInfoSelectionItemView *schoolView;
@property (nonatomic, strong) PersonalInfoSelectionItemView *stageView;
@property (nonatomic, strong) LoginActionView *submitButton;
@end

@implementation CompletePersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"完善资料";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(200*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    
    self.nameView = [[ClassInfoItemView alloc]init];
    self.nameView.name = @"你的姓名";
    self.nameView.inputView.placeHolder = @"请输入真实姓名";
    WEAK_SELF
    [self.nameView setTextChangeBlock:^{
        STRONG_SELF
        [self submitButton];
    }];
    [containerView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.schoolView = [[PersonalInfoSelectionItemView alloc]init];
    self.schoolView.name = @"学校";
    [self.schoolView setActionBlock:^{
        STRONG_SELF
        [self gotoSchoolSelection];
    }];
    [containerView addSubview:self.schoolView];
    [self.schoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    
    self.stageView = [[PersonalInfoSelectionItemView alloc]init];
    self.stageView.name = @"学段";
    [self.stageView setActionBlock:^{
        STRONG_SELF
        [self gotoStageSelection];
    }];
    [containerView addSubview:self.stageView];
    [self.stageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.schoolView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    self.submitButton = [[LoginActionView alloc]init];
    self.submitButton.title = @"提 交";
    [self.submitButton setActionBlock:^{
        STRONG_SELF
    }];
    [self.contentView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshSubmitButton];
}

- (void)refreshSubmitButton {
    self.submitButton.isActive = !isEmpty(self.nameView.text);
}

- (void)gotoStageSelection {
    StageSelectionViewController *vc = [[StageSelectionViewController alloc]init];
    WEAK_SELF
    [vc setCompleteBlock:^(NSString *stageName,NSString *stageID){
        STRONG_SELF
        self.stageView.text = stageName;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSchoolSelection {
    AreaSelectionViewController *vc = [[AreaSelectionViewController alloc]init];
    vc.baseVC = self;
    WEAK_SELF
    [vc setSchoolSearchBlock:^(YXSchool *school){
        STRONG_SELF
        self.schoolView.text = school.name;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

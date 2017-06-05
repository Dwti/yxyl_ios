//
//  HomeworkClassInfoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkClassInfoViewController.h"
#import "ClassInfoItemView.h"
#import "LoginActionView.h"

@interface HomeworkClassInfoViewController ()

@end

@implementation HomeworkClassInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"班级信息";
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
        make.height.mas_equalTo(120*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(57);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    UILabel *classNameLabel = [[UILabel alloc]init];
    NSString *classInfo = [NSString stringWithFormat:@"%@%@",self.rawData.gradename,self.rawData.name];
    classNameLabel.text = classInfo;
    classNameLabel.font = [UIFont boldSystemFontOfSize:19];
    classNameLabel.textColor = [UIColor whiteColor];
    classNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:classNameLabel];
    [classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(containerView.mas_top).mas_offset(-22);
        make.centerX.mas_equalTo(self.contentView).mas_offset(6);
    }];
    UIView *dotView = [[UIView alloc]init];
    dotView.backgroundColor = [UIColor whiteColor];
    dotView.layer.cornerRadius = 2.5;
    dotView.clipsToBounds = YES;
    [self.contentView addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(classNameLabel.mas_centerY);
        make.right.mas_equalTo(classNameLabel.mas_left).mas_offset(-8);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    
    ClassInfoItemView *classCodeView = [[ClassInfoItemView alloc]init];
    classCodeView.name = @"班级号码";
    classCodeView.inputView.textField.text = self.rawData.gid;
    classCodeView.userInteractionEnabled = NO;
    [containerView addSubview:classCodeView];
    [classCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *teacherNameView = [[ClassInfoItemView alloc]init];
    teacherNameView.name = @"老师姓名";
    teacherNameView.inputView.textField.text = self.rawData.adminName;
    teacherNameView.userInteractionEnabled = NO;
    [containerView addSubview:teacherNameView];
    [teacherNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classCodeView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *classMemberView = [[ClassInfoItemView alloc]init];
    classMemberView.name = @"班级成员";
    classMemberView.inputView.textField.text = [NSString stringWithFormat:@"%@人",self.rawData.stdnum];
    classMemberView.userInteractionEnabled = NO;
    [containerView addSubview:classMemberView];
    [classMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(teacherNameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *schoolNameView = [[ClassInfoItemView alloc]init];
    schoolNameView.name = @"学校名称";
    schoolNameView.inputView.textField.text = self.rawData.schoolname;
    schoolNameView.userInteractionEnabled = NO;
    [containerView addSubview:schoolNameView];
    [schoolNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classMemberView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    LoginActionView *actionView = [[LoginActionView alloc]init];
    if (self.isVerifying) {
        actionView.title = @"取消申请";
    }else {
        actionView.title = @"退出班级";
    }
    WEAK_SELF
    [actionView setActionBlock:^{
        STRONG_SELF
        [self gotoClassAction];
    }];
    [self.contentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
}

- (void)gotoClassAction {
    if (self.isVerifying) {
        [self cancelJoiningClass];
    }else {
        [self exitClass];
    }
}
- (void)cancelJoiningClass {
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager cancelJoiningClassWithClassID:self.rawData.gid completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)exitClass {
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager exitClassWithClassID:self.rawData.gid completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end

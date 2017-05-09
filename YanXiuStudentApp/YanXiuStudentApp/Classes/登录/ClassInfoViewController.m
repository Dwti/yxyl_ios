//
//  ClassInfoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "ClassInfoItemView.h"
#import "LoginActionView.h"

@interface ClassInfoViewController ()
@property (nonatomic, strong) ClassInfoItemView *nameView;
@property (nonatomic, strong) LoginActionView *addClassButton;
@end

@implementation ClassInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:@"加入班级 - 提交资料"];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(0, 4)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(4, 7)];
    titleLabel.attributedText = attrString;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
    classNameLabel.text = @"七年级20班";
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
    classCodeView.inputView.textField.text = @"12345678";
    classCodeView.userInteractionEnabled = NO;
    [containerView addSubview:classCodeView];
    [classCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *teacherNameView = [[ClassInfoItemView alloc]init];
    teacherNameView.name = @"老师姓名";
    teacherNameView.inputView.textField.text = @"宋江";
    teacherNameView.userInteractionEnabled = NO;
    [containerView addSubview:teacherNameView];
    [teacherNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classCodeView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *classMemberView = [[ClassInfoItemView alloc]init];
    classMemberView.name = @"班级成员";
    classMemberView.inputView.textField.text = @"108人";
    classMemberView.userInteractionEnabled = NO;
    [containerView addSubview:classMemberView];
    [classMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(teacherNameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *schoolNameView = [[ClassInfoItemView alloc]init];
    schoolNameView.name = @"学校名称";
    schoolNameView.inputView.textField.text = @"梁山大学";
    schoolNameView.userInteractionEnabled = NO;
    [containerView addSubview:schoolNameView];
    [schoolNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classMemberView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameView = [[ClassInfoItemView alloc]init];
    self.nameView.name = @"你的姓名";
    self.nameView.inputView.placeHolder = @"请输入你的真实姓名";
    self.nameView.layer.cornerRadius = 5;
    self.nameView.clipsToBounds = YES;
    WEAK_SELF
    [self.nameView setTextChangeBlock:^{
        STRONG_SELF
        [self refreshAddClassButton];
    }];
    [self.contentView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    
    self.addClassButton = [[LoginActionView alloc]init];
    self.addClassButton.title = @"加入班级";
    [self.addClassButton setActionBlock:^{
        STRONG_SELF
    }];
    [self.contentView addSubview:self.addClassButton];
    [self.addClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameView.mas_left);
        make.right.mas_equalTo(self.nameView.mas_right);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshAddClassButton];
}

- (void)refreshAddClassButton {
    self.addClassButton.isActive = !isEmpty(self.nameView.text);
}

@end

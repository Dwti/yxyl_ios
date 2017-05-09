//
//  AddClassViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AddClassViewController.h"
#import "ClassNumberInputView.h"
#import "LoginActionView.h"
#import "ClassInfoViewController.h"
#import "CompletePersonalInfoViewController.h"

@interface AddClassViewController ()
@property (nonatomic, strong) ClassNumberInputView *numberInputView;
@property (nonatomic, strong) LoginActionView *nextStepButton;
@end

@implementation AddClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"加入班级";
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
    self.numberInputView = [[ClassNumberInputView alloc]init];
    self.numberInputView.numberCount = 8;
    WEAK_SELF
    [self.numberInputView setTextChangeBlock:^(NSString *text){
        STRONG_SELF
        self.nextStepButton.isActive = !isEmpty(text);
    }];
    [self.contentView addSubview:self.numberInputView];
    [self.numberInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
        make.height.mas_equalTo(50);
    }];
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.text = @"请输入8位班级号";
    topLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.numberInputView.mas_top).mas_offset(-12);
    }];
    LoginActionView *nextStepView = [[LoginActionView alloc]init];
    nextStepView.title = @"下一步";
    nextStepView.isActive = NO;
    [nextStepView setActionBlock:^{
        STRONG_SELF
        ClassInfoViewController *vc = [[ClassInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.contentView addSubview:nextStepView];
    [nextStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberInputView.mas_left);
        make.right.mas_equalTo(self.numberInputView.mas_right);
        make.top.mas_equalTo(self.numberInputView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    self.nextStepButton = nextStepView;
    
    UIButton *skipButton = [[UIButton alloc]init];
    [skipButton setTitle:@"没有班级可加，跳过此步" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateHighlighted];
    [skipButton setImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [skipButton.titleLabel sizeToFit];
    skipButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
    skipButton.imageEdgeInsets = UIEdgeInsetsMake(0, skipButton.titleLabel.width+3, 0, -skipButton.titleLabel.width-3);
    [self.contentView addSubview:skipButton];
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nextStepButton.mas_left);
        make.right.mas_equalTo(self.nextStepButton.mas_right);
        make.top.mas_equalTo(self.nextStepButton.mas_bottom).mas_offset(30);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self.numberInputView becomeFirstResponder];
}

- (void)skipAction {
    CompletePersonalInfoViewController *vc = [[CompletePersonalInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  EditNameViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "EditNameViewController.h"

@interface NameInputField : UITextField

@end
@implementation NameInputField
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 26);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 26);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 26);
}
@end

@interface EditNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NameInputField *textField;
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation EditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"姓名";
    UIButton *naviRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [naviRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [naviRightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    naviRightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    naviRightButton.layer.cornerRadius = 6;
    naviRightButton.layer.borderWidth = 2;
    naviRightButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    naviRightButton.clipsToBounds = YES;
    WEAK_SELF
    [[naviRightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self saveName];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.shadowOffset = CGSizeMake(0, 1);
    bgView.layer.shadowRadius = 1;
    bgView.layer.shadowOpacity = 0.02;
    bgView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(75);
    }];
    UIButton *clearButton = [[UIButton alloc]init];
    [clearButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    clearButton.hidden = YES;
    self.clearButton = clearButton;
    
    self.textField = [[NameInputField alloc]init];
    self.textField.font = [UIFont boldSystemFontOfSize:19];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.text = [YXUserManager sharedManager].userModel.realname;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.clipsToBounds = YES;
    [bgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(clearButton.mas_left).mas_offset(-12);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.textField rac_textSignal]subscribeNext:^(NSString *x) {
        STRONG_SELF
        if (x.length > 16) {
            self.textField.text = [x substringWithRange:NSMakeRange(0, 16)];
        }
        if (self.textField.isFirstResponder) {
            self.clearButton.hidden = isEmpty(x);
        }else {
            self.clearButton.hidden = YES;
        }
    }];
}

- (void)clearAction {
    self.textField.text = @"";
    self.clearButton.hidden = YES;
}

- (void)saveName {
    [self.textField resignFirstResponder];
    if (isEmpty(self.textField.text)) {
        [self.view nyx_showToast:@"姓名不能为空"];
        return;
    }
    if ([self.textField.text isEqualToString:[YXUserManager sharedManager].userModel.realname]) {
        [self backAction];
        return;
    }
    
    WEAK_SELF
    [self nyx_disableRightNavigationItem];
    [self.view nyx_startLoading];
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeRealname param:@{@"realname":self.textField.text} completion:^(NSError *error) {
        STRONG_SELF
        [self nyx_enableRightNavigationItem];
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self backAction];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

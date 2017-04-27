//
//  YXModifyNameViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXModifyNameViewController_Pad.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXWordInputView.h"

@interface YXModifyNameViewController_Pad ()

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) YXWordInputView *inputView;

@end

@implementation YXModifyNameViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"姓名";
    self.saveButton = [self yx_setupRightButtonItemWithTitle:@"保存" image:nil highLightedImage:nil];
    [self setupUI];
}

- (void)setupUI
{
    self.inputView = [[YXWordInputView alloc] init];
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(75);
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-75);
        make.height.mas_equalTo(60);
    }];
    
    @weakify(self);
    self.inputView.textChangeBlock = ^(NSString *text){
        @strongify(self);
        if (text.length > 25) {
            self.inputView.text = [text substringToIndex:25];
        }
        [self resetButtonEnable];
    };
    self.inputView.rightClick = ^{
        @strongify(self);
        if (!self) {
            return;
        }
        self.inputView.text = nil;
        [self resetButtonEnable];
    };
    self.inputView.text = [YXUserManager sharedManager].userModel.realname;
    [self resetButtonEnable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yx_rightButtonPressed:(id)sender
{
    [self.inputView resignFirstResponder];
    if ([[self realname] isEqualToString:[YXUserManager sharedManager].userModel.realname]) {
        [self yx_leftBackButtonPressed:nil];
        return;
    }
    
    @weakify(self);
    [self yx_startLoading];
    self.saveButton.enabled = NO;
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeRealname param:@{@"realname":[self realname]} completion:^(NSError *error) {
        @strongify(self);
        self.saveButton.enabled = YES;
        [self yx_stopLoading];
        if (!error) {
            [self yx_leftBackButtonPressed:nil];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[YXUpdateUserInfoHelper instance] stopRequest];
}

#pragma mark -

- (void)resetButtonEnable
{
    if ([[self realname] yx_isValidString]) {
        self.saveButton.enabled = YES;
    } else {
        self.saveButton.enabled = NO;
    }
}

#pragma mark -

- (NSString *)realname
{
    return [self.inputView.text yx_stringByTrimmingCharacters];
}

@end

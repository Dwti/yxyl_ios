//
//  StageSelectionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "StageSelectionViewController.h"

@interface StageSelectionViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL separatorSetupComplete;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation StageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"选择学段";
    UIButton *naviRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [naviRightButton setTitle:@"确定" forState:UIControlStateNormal];
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
        BLOCK_EXEC(self.completeBlock,[YXMineManager stageNames][self.currentIndex],[YXMineManager stageIds][self.currentIndex]);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(400);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-30);
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [YXMineManager stageNames].count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.view.width-30);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    if (!self.separatorSetupComplete) {
        for(UIView *singleLine in pickerView.subviews) {
            if (singleLine.frame.size.height < 1) {
                singleLine.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
                CGRect rect = singleLine.frame;
                rect.origin.y -= 1;
                rect.size.height = 2;
                singleLine.frame = rect;
            }
        }
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [YXMineManager stageNames][row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

@end

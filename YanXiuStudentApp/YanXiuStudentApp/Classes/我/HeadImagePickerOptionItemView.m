//
//  HeadImagePickerOptionItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HeadImagePickerOptionItemView.h"

@interface HeadImagePickerOptionItemView()
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, strong) UILabel *label;
@end

@implementation HeadImagePickerOptionItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.itemButton = [[UIButton alloc]init];
    [self.itemButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(95, 95));
    }];
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont boldSystemFontOfSize:21];
    self.label.textColor = [UIColor colorWithHexString:@"336600"];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.itemButton.mas_bottom).mas_offset(9);
        make.centerX.mas_equalTo(self.itemButton.mas_centerX);
    }];
}

- (void)updateWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title {
    [self.itemButton setImage:image forState:UIControlStateNormal];
    [self.itemButton setImage:highlightImage forState:UIControlStateHighlighted];
    self.label.text = title;
}

- (void)btnAction {
    BLOCK_EXEC(self.actionBlock);
}

@end

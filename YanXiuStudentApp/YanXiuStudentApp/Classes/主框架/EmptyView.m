//
//  EmptyView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/8/1.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(250*kPhoneWidthRatio);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"无内容";
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
    }];

    self.topImageView = topImageView;
    self.descLabel = label;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([title yx_isValidString]) {
        self.descLabel.text = title;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.topImageView.image = image;
}

@end

//
//  QAReportNavView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportNavView.h"
#import "UIButton+ExpandHitArea.h"

@interface QAReportNavView ()
@property (nonatomic, strong) UIButton *backbutton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) BackActionBlock buttonActionBlock;

@end


@implementation QAReportNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backbutton setHitTestEdgeInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
    [self.backbutton setImage:[UIImage imageNamed:@"返回上一页icon白色正常态"] forState:UIControlStateNormal];
    [self.backbutton setImage:[UIImage imageNamed:@"返回上一页icon白色点击态"] forState:UIControlStateHighlighted];
    [self.backbutton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    
    [self addSubview:self.backbutton];
    [self addSubview:self.titleLabel];

    [self.backbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backbutton.mas_right).offset(15.0f);
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.backbutton);
    }];
}

- (void)backButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.buttonActionBlock);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setBackActionBlock:(BackActionBlock)block {
    self.buttonActionBlock = block;
}

@end

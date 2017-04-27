//
//  YXJieXiShowView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/7/23.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXJieXiShowView.h"
#import "YXQADashLineView.h"

@implementation YXJieXiShowView{
    UIButton *btn;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    btn = [[UIButton alloc]init];
    [btn setTitle:@"显示解析" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"显示解析按钮背景"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"显示解析按钮背景-按下"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    btn.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    btn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    btn.titleLabel.layer.shadowRadius = 0;
    btn.titleLabel.layer.shadowOpacity = 1;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.height.mas_equalTo(58);
    }];

}

- (void)btnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAnalysisData)]) {
        [self.delegate showAnalysisData];
    }
}

+ (CGFloat)height{
    return 120;
}

@end

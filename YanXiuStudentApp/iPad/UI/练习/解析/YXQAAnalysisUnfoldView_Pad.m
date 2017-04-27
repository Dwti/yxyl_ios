//
//  YXQAAnalysisUnfoldView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisUnfoldView_Pad.h"

@implementation YXQAAnalysisUnfoldView_Pad

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    self.backgroundView = bgView;
    
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"显示解析" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage yx_resizableImageNamed:@"显示解析按钮背景"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage yx_resizableImageNamed:@"显示解析按钮背景-按下"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(36);
        make.right.mas_equalTo(-37);
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

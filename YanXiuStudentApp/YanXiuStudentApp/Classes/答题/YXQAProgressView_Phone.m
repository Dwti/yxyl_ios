//
//  YXQAProgressView_Phone.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAProgressView_Phone.h"

@interface YXQAProgressView_Phone()
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation YXQAProgressView_Phone

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.preButton = [self giveMeButtonWithTitle:@"上一题"];
    self.nextButton = [self giveMeButtonWithTitle:@"下一题"];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:11];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"807c6c"];
    [self addSubview:self.preButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.progressLabel];
    
    [self.preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.preButton.mas_right).mas_offset(5);
        make.right.mas_equalTo(self.nextButton.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(0);
    }];
}

- (UIButton *)giveMeButtonWithTitle:(NSString *)title{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage yx_resizableImageNamed:@"上下一题背景"] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage yx_resizableImageNamed:@"上下一题按下背景"] forState:UIControlStateHighlighted];
    [b setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [b.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"ffff99"]];
    b.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)btnAction:(UIButton *)sender{
    if (sender == self.preButton) {
        BLOCK_EXEC(self.preBlock);
    }else if (sender == self.nextButton){
        BLOCK_EXEC(self.nextBlock);
    }
}

- (void)updateWithIndex:(NSInteger)index total:(NSInteger)total{
    if (index == total) {
        --index;
    }
    NSString *indexString = [NSString stringWithFormat:@"%@",@(index+1)];
    NSString *totalString = [NSString stringWithFormat:@"%@",@(total)];
    NSString *completeString = [NSString stringWithFormat:@"%@ / %@",indexString,totalString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:completeString];
    NSRange indexRange = [completeString rangeOfString:indexString];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Bold size:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"807c6c"]} range:indexRange];
    self.progressLabel.attributedText = attrString;
}

- (void)setPreHidden:(BOOL)preHidden{
    _preHidden = preHidden;
    self.preButton.hidden = preHidden;
}

- (void)setNextHidden:(BOOL)nextHidden{
    _nextHidden = nextHidden;
    self.nextButton.hidden = nextHidden;
}

@end

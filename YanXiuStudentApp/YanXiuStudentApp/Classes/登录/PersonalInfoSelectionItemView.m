//
//  PersonalInfoSelectionItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PersonalInfoSelectionItemView.h"
#import "PrefixHeader.pch"

@interface PersonalInfoSelectionItemView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *coverButton;
@end

@implementation PersonalInfoSelectionItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(-51);
    }];
    UIButton *coverButton = [[UIButton alloc]init];
    [coverButton setImage:[UIImage imageNamed:@"完善资料学校箭头icon正常态"] forState:UIControlStateNormal];
    [coverButton setImage:[UIImage imageNamed:@"完善资料学校箭头icon点击态"] forState:UIControlStateNormal];
    [coverButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coverButton];
    [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.coverButton = coverButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat t = (self.coverButton.width-17*2-17)/2;
    self.coverButton.imageEdgeInsets = UIEdgeInsetsMake(0, t, 0, -t);
}

- (void)btnAction {
    BLOCK_EXEC(self.actionBlock)
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (void)setText:(NSString *)text {
    self.contentLabel.text = text;
}

- (NSString *)text {
    return self.contentLabel.text;
}

@end

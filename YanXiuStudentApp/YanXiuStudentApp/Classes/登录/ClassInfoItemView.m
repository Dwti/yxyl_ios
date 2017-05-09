//
//  ClassInfoItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassInfoItemView.h"

@interface ClassInfoItemView()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation ClassInfoItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
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
    self.inputView = [[LoginInputView alloc]init];
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(-20);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

@end

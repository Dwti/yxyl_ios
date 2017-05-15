//
//  ClassInfoItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassInfoItemView.h"

@interface ClassInfoItemView()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *pencilView;
@end

@implementation ClassInfoItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
        self.canEdit = NO;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.pencilView = [[UIImageView alloc]init];
    self.pencilView.image = [UIImage imageWithColor:[UIColor redColor]];
    [self addSubview:self.pencilView];
    
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
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (canEdit) {
        [self addSubview:self.pencilView];
        [self.pencilView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
            make.right.mas_equalTo(self.pencilView.mas_left).mas_offset(-17);
        }];
    }else {
        [self.pencilView removeFromSuperview];
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
            make.right.mas_equalTo(-17);
        }];
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

@end

//
//  QAYesNoOptionCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAYesNoOptionCell.h"

@interface QAYesNoOptionCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectionImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation QAYesNoOptionCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.selectionImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.selectionImageView];
    [self.selectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    self.bottomLineView = bottomLineView;
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"e6e8e6"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast) {
        self.bottomLineView.hidden = YES;
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.bottomLineView.hidden = NO;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

- (void)setChoosed:(BOOL)choosed {
    _choosed = choosed;
    if (choosed) {
        self.selectionImageView.backgroundColor = [UIColor greenColor];
    }else {
        self.selectionImageView.backgroundColor = [UIColor redColor];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


@end

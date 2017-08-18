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
@property (nonatomic, strong) UIImageView *orderBgImageView;
@property (nonatomic, strong) UIImageView *selectionImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation QAYesNoOptionCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.isAnalysis) {
        return;
    }
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
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOpacity = 0.02;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.orderBgImageView = [[UIImageView alloc]init];
    [self.contentView insertSubview:self.orderBgImageView belowSubview:self.titleLabel];
    [self.orderBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(39, 39));
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
        self.selectionImageView.image = [UIImage imageNamed:@"单选框已选择"];
    }else {
        self.selectionImageView.image = [UIImage imageNamed:@"选择框"];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setMarkType:(OptionCellMarkType)markType {
    _markType = markType;
    if (markType == OptionMarkType_Correct) {
        self.orderBgImageView.image = [UIImage imageNamed:@"答对题目-正常态"];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.choosed = self.choosed;
    }else if (markType == OptionMarkType_Wrong) {
        self.orderBgImageView.image = [UIImage imageNamed:@"答错题目-正常态"];
        self.titleLabel.textColor = [UIColor whiteColor];
        if (self.choosed) {
            self.selectionImageView.image = [UIImage imageNamed:@"单选题已选择错误"];
        }
    }else {
        self.orderBgImageView.image = nil;
        self.choosed = self.choosed;
    }
}

@end

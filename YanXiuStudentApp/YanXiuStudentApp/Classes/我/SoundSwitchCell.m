//
//  SoundSwitchCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SoundSwitchCell.h"

@interface SoundSwitchCell()
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UISwitch *switchView;
@property(nonatomic, copy) SwitchActionBlock block;
@end

@implementation SoundSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
        self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.02;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.itemLabel = [[UILabel alloc]init];
    self.itemLabel.font = [UIFont boldSystemFontOfSize:16];
    self.itemLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.itemLabel];
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.switchView = [[UISwitch alloc]init];
    self.switchView.onTintColor = [UIColor colorWithHexString:@"89e00d"];
    [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
    }];

    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)switchAction:(UISwitch *)sender {
    BLOCK_EXEC(self.block,self.switchView.on);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.itemLabel.text = title;
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    self.switchView.on = isOn;
}

- (void)setShouldShowShadow:(BOOL)shouldShowShadow {
    _shouldShowShadow = shouldShowShadow;
    if (shouldShowShadow) {
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
}

- (void)setSwitchActionBlock:(SwitchActionBlock)block {
    self.block = block;
}
@end

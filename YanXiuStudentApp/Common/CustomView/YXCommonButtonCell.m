//
//  YXCommonButtonCell.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/18.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXCommonButtonCell.h"
#import "UIColor+YXColor.h"
#import "UIView+YXScale.h"

NSString *const kCommonButtonCellIdentifier = @"kCommonButtonCellIdentifier";

@implementation YXCommonButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setupViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setButtonText:(NSString *)text
{
    self.textLabel.text = text;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"通用按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"通用按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 20, 30)]];
    UIColor *color = [UIColor yx_colorWithHexString:@"805500"];
    self.textLabel.textColor = color;
    self.textLabel.highlightedTextColor = [color colorWithAlphaComponent:0.5f];
    self.textLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.textLabel.shadowOffset = CGSizeMake(0, 1);
    self.textLabel.font = [UIFont boldSystemFontOfSize:20];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.selectedBackgroundView.frame = self.backgroundView.frame;
    self.textLabel.frame = self.backgroundView.frame;
}

@end

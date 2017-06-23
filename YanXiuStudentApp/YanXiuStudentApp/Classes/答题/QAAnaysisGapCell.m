//
//  QAAnaysisGapCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnaysisGapCell.h"

static const CGFloat kGapCellHeight = 10.0f;

@implementation QAAnaysisGapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
}

+ (CGFloat)height {
    return kGapCellHeight;
}
@end

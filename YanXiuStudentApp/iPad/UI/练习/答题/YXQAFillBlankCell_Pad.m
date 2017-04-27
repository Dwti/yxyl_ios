//
//  YXQAFillBlankCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAFillBlankCell_Pad.h"
#import "YXQAUtils.h"

@implementation YXQAFillBlankCell_Pad


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIImageView *q = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Q"]];
    [self.contentView addSubview:q];
    [q mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(27);
        make.size.mas_equalTo(CGSizeMake(28, 30));
    }];
    
    UIImageView *stemBgView = [[UIImageView alloc]initWithImage:[YXQAUtils stemBgImage]];
    [self.contentView addSubview:stemBgView];
    [stemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(73);
        make.top.mas_equalTo(20).priorityHigh();
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-20).priorityHigh();
    }];
}

@end

//
//  YXMineSelectCell.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineSelectCell.h"

NSString *const kYXMineSelectCellIdentifier = @"kYXMineSelectCellIdentifier";

@implementation YXMineSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色对勾"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.accessoryView.hidden = NO;
    } else {
        self.accessoryView.hidden = YES;
    }
}

@end

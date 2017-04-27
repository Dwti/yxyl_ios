//
//  QAClassifyClassesCell.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyClassesCell.h"

@implementation QAClassifyClassesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

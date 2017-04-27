//
//  YXQATitleCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQATitleCell_Pad.h"

@interface YXQATitleCell_Pad()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXQATitleCell_Pad


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(39);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(46, 18));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"b2a8bf"];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(13);
    }];
    
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setItem:(QAQuestion *)item{
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

@end

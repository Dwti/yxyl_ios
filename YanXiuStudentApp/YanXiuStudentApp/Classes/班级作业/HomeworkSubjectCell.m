//
//  HomeworkSubjectCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkSubjectCell.h"

@interface HomeworkSubjectCell()
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *dotView;
@end

@implementation HomeworkSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
    
    self.subjectLabel = [[UILabel alloc]init];
    self.subjectLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.subjectLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.subjectLabel];
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    self.dotView = [[UIImageView alloc]init];
    self.dotView.layer.cornerRadius = 1;
    self.dotView.clipsToBounds = YES;
    [self.contentView addSubview:self.dotView];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(2, 2));
    }];
    UIView *seperatorView = [[UIView alloc]init];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:seperatorView];
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setData:(YXHomeworkListGroupsItem_Data *)data {
    _data = data;
    self.subjectLabel.text = data.name;
    if (data.waitFinishNum.integerValue > 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@份待完成", data.waitFinishNum];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
        self.dotView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]];
    }else {
        self.statusLabel.text = @"查看已完成";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.dotView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"999999"]];
    }
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast) {
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

@end

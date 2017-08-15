//
//  ExerciseHistorySubjectCell.m
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistorySubjectCell.h"

@interface ExerciseHistorySubjectCell ()

@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation ExerciseHistorySubjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.accessoryImageView.image = [UIImage imageNamed:@"展开内容按钮点击态"];
    }else {
        self.accessoryImageView.image = [UIImage imageNamed:@"展开内容按钮正常态"];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.whiteBackView = [[UIView alloc] init];
    self.whiteBackView.backgroundColor = [UIColor whiteColor];
    self.whiteBackView.layer.shadowOffset = CGSizeMake(0, 1);
    self.whiteBackView.layer.shadowRadius = 1;
    self.whiteBackView.layer.shadowOpacity = 0.02;
    [self.contentView addSubview:self.whiteBackView];
    [self.whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.centerY.mas_equalTo(self.whiteBackView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
    
    UIImageView *accessoryImageView = [[UIImageView alloc] init];
    accessoryImageView.image = [UIImage imageNamed:@"展开内容按钮正常态"];
    [self.contentView addSubview:accessoryImageView];
    [accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)setSubject:(GetPracticeEditionRequestItem_subject *)subject {
    self.titleLabel.text = subject.name;
    self.iconImageView.image = [UIImage imageNamed:subject.name];
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    if (isLast) {
        self.whiteBackView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    } else {
        self.whiteBackView.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

@end

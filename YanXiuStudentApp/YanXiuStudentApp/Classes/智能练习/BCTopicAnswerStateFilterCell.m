//
//  BCTopicAnswerStateFilterCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicAnswerStateFilterCell.h"

@interface BCTopicAnswerStateFilterCell ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation BCTopicAnswerStateFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selectedImageView.hidden = NO;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }else {
        self.selectedImageView.hidden = YES;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下拉内容-选择按钮"]];
    [self.contentView addSubview:self.selectedImageView];
    self.selectedImageView.hidden = YES;
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setShouldShowLine:(BOOL)shouldShowLine {
    _shouldShowLine = shouldShowLine;
    if (shouldShowLine) {
        self.bottomLineView.hidden = NO;
    }else {
        self.bottomLineView.hidden = YES;
    }
}
@end

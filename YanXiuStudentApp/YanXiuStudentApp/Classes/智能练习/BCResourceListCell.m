//
//  BCResourceListCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCResourceListCell.h"

@interface BCResourceListCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation BCResourceListCell

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
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
        self.enterImageView.image = [UIImage imageNamed:@"BC资源列表展开内容按钮点击态"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.enterImageView.image = [UIImage imageNamed:@"BC资源列表展开内容按钮正常态"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImageView *enterImageView = [[UIImageView alloc]init];
    enterImageView.image = [UIImage imageNamed:@"BC资源列表展开内容按钮正常态"];
    [self.contentView addSubview:enterImageView];
    self.enterImageView = enterImageView;
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setShouldShowLine:(BOOL)shouldShowLine {
    _shouldShowLine = shouldShowLine;
    if (shouldShowLine) {
        self.bottomLineView.hidden = NO;
    }else {
        self.bottomLineView.hidden = YES;
    }
}

- (void)setResourceTitle:(NSString *)resourceTitle {
    _resourceTitle = resourceTitle;
    self.titleLabel.text = resourceTitle;
}

@end

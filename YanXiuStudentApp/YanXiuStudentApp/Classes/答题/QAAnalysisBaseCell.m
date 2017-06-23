//
//  QAAnalysisBaseCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisBaseCell.h"

@interface QAAnalysisBaseCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation QAAnalysisBaseCell

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
        self.isShowLine = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    
    self.containerView = [[UIView alloc]init];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"81d40d"];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.containerView];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.titleLabel);
        make.bottom.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    if (isShowLine) {
        self.lineView.hidden = NO;
    }else {
        self.lineView.hidden = YES;
    }
}

- (void)setItem:(YXQAAnalysisItem *)item {
    _item = item;
    self.titleLabel.text = [item typeString];
}
@end

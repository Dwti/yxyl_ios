//
//  ExerciseKnpTreeCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseKnpTreeCell.h"
#import "YXMasterProgressView.h"
#import "YXDashLineCell.h"
#import "YXCommonLabel.h"
typedef void(^ExpandBlock) (ExerciseKnpTreeCell *cell);
typedef void(^ClickBlock) (ExerciseKnpTreeCell *cell);
@interface ExerciseKnpTreeCell()
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIButton *contentBgButton;
@property (nonatomic, strong) YXCommonLabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UIView *progressContainerView;
@property (nonatomic, strong) YXCommonLabel *masterTitleLabel;
@property (nonatomic, strong) YXMasterProgressView *masterProgressView;
@property (nonatomic, strong) YXCommonLabel *masterProgressLabel;

@property (nonatomic, copy) ExpandBlock expandBlock;
@property (nonatomic, copy) ClickBlock clickBlock;
@end

@implementation ExerciseKnpTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    self.expandButton = [[UIButton alloc]init];
    [self.expandButton addTarget:self action:@selector(expandButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    
    self.contentBgButton = [[UIButton alloc]init];
    [self.contentBgButton addTarget:self action:@selector(contentBgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.contentBgButton];
    
    self.titleLabel = [[YXCommonLabel alloc]init];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
    self.progressContainerView = [[UIView alloc] init];
    self.progressContainerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.progressContainerView];
    [self.progressContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgButton.mas_left);
        make.right.mas_equalTo(self.contentBgButton.mas_right);
        make.height.mas_equalTo(32).priorityHigh();
        make.bottom.mas_equalTo(-14);
    }];
    
    self.accessoryImageView = [[UIImageView alloc] init];
    self.accessoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.accessoryImageView.image = [UIImage imageNamed:@"蓝色右箭头"];
    [self.contentView addSubview:self.accessoryImageView];
    
    YXDashLineCell *cell = [[YXDashLineCell alloc] init];
    cell.realWidth = 4;
    cell.dashWidth = 3;
    cell.preferedGapToCellBounds = 0;
    cell.bHasShadow = YES;
    cell.realColor = [UIColor colorWithHexString:@"e4b62e"];
    cell.shadowColor = [UIColor colorWithHexString:@"ffeb66"];
    [self.progressContainerView addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(4.5);
        make.right.mas_equalTo(-4.5);
        make.height.mas_equalTo(2);
    }];
    self.masterProgressView = [[YXMasterProgressView alloc] init];
    [self.progressContainerView addSubview:self.masterProgressView];
    self.masterTitleLabel = [[YXCommonLabel alloc] init];
    self.masterTitleLabel.font = [UIFont systemFontOfSize:11];
    [self.progressContainerView addSubview:self.masterTitleLabel];
    self.masterProgressLabel = [[YXCommonLabel alloc] init];
    [self.progressContainerView addSubview:self.masterProgressLabel];
    
    [self.masterProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.masterTitleLabel.mas_right);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-70);
    }];
    [self.masterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressContainerView.mas_left).offset(18.0f);
        make.centerY.equalTo(self.progressContainerView.mas_centerY);
    }];
    [self.masterProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressContainerView.mas_centerY);
        make.right.equalTo(self.progressContainerView.mas_right).offset(-15);
        make.left.mas_greaterThanOrEqualTo(self.masterProgressView.mas_right).offset(4);
    }];
    
    self.level = 0;
    self.isExpand = NO;
}

- (void)setupUIForFirstLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expandButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgButton.mas_left).mas_offset(24);
        make.top.mas_equalTo(14 + 4);
        make.bottom.mas_equalTo(self.progressContainerView.mas_top).offset(-10 - 4);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"一级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.masterTitleLabel.text = @"考点完全掌握：";
    NSString *totalString = [NSString stringWithFormat:@"/%@", self.knp.data.totalNum];
    self.masterProgressLabel.attributedText = [self knpFirst:self.knp.data.masterNum Second:totalString];
    CGFloat progress = 0;
    if (isEmpty(self.knp.data.totalNum) || isEmpty(self.knp.data.masterNum)) {
    } else {
        progress = [self.knp.data.masterNum floatValue] / [self.knp.data.totalNum floatValue];
    }
    self.masterProgressView.progress = progress;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
}

- (void)setupUIForSecondLevel {
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.centerY.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.expandButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgButton.mas_left).mas_offset(20);
        make.top.mas_equalTo(12 + 3);
        make.bottom.mas_equalTo(self.progressContainerView.mas_top).offset(-7 - 3);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"二级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.masterTitleLabel.text = @"考点完全掌握：";
    NSString *totalString = [NSString stringWithFormat:@"/%@", self.knp.data.totalNum];
    self.masterProgressLabel.attributedText = [self knpFirst:self.knp.data.masterNum Second:totalString];
    CGFloat progress = 0;
    if (isEmpty(self.knp.data.totalNum) || isEmpty(self.knp.data.masterNum)) {
    } else {
        progress = [self.knp.data.masterNum floatValue] / [self.knp.data.totalNum floatValue];
    }
    self.masterProgressView.progress = progress;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)setupUIForThirdLevel {
    [self.contentBgButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    [self.accessoryImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentBgButton.mas_left).mas_offset(24);
        make.right.mas_equalTo(-10-25-21-10);
        make.top.mas_equalTo(11 + 3);
        make.bottom.mas_equalTo(self.progressContainerView.mas_top).offset(-7 - 3);
    }];
    
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景"] forState:UIControlStateNormal];
    [self.contentBgButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"三级目录背景按下"] forState:UIControlStateHighlighted];
    
    self.masterTitleLabel.text = @"考点掌握度：";
    int percent = (int)([self percentFromString:self.knp.data.masterLevel] * 100);
    self.masterProgressLabel.attributedText = [self knpFirst:[NSString stringWithFormat:@"%@", @(percent)] Second:@"%"];
    CGFloat progress = 0;
    if (isEmpty(self.knp.data.masterLevel)) {
    } else {
        progress = [self percentFromString:self.knp.data.masterLevel];
    }
    self.masterProgressView.progress = progress;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
}

#pragma mark - set

- (void)setLevel:(NSInteger)level {
    [super setLevel:level];
    if (level == 0) {
        [self setupUIForFirstLevel];
    }else if (level == 1) {
        [self setupUIForSecondLevel];
    }else {
        [self setupUIForThirdLevel];
    }
    if ([self clickableWithLevel:self.level]) {
        self.accessoryImageView.hidden = NO;
    } else {
        self.accessoryImageView.hidden = YES;
    }
}

- (void)setIsExpand:(BOOL)isExpand {
    [super setIsExpand:isExpand];
    if (self.isExpand) {
        if (self.level == 0) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号"] forState:UIControlStateNormal];
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级黄色-号-按下"] forState:UIControlStateHighlighted];
        }else if (self.level == 1) {
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号"] forState:UIControlStateNormal];
            [self.expandButton setBackgroundImage:[UIImage imageNamed:@"二级黄色-号-按下"] forState:UIControlStateHighlighted];
        }
    }else {
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号"] forState:UIControlStateNormal];
        [self.expandButton setBackgroundImage:[UIImage imageNamed:@"一级蓝色+号-按下"] forState:UIControlStateHighlighted];
    }
}

- (void)setKnp:(GetKnpListRequestItem_knp *)knp {
    _knp = knp;
    self.titleLabel.text = knp.name;
    self.expandButton.hidden = (knp.children.count == 0);
}

- (void)setTreeExpandBlock:(ExpandBlock)block {
    self.expandBlock = block;
}

- (void)setTreeClickBlock:(ClickBlock)block {
    self.clickBlock = block;
}
#pragma mark - Actions
- (void)expandButtonAction {
    BLOCK_EXEC(self.expandBlock,self);
}

- (void)contentBgButtonAction {
    if (![self clickableWithLevel:self.level]) {
        BLOCK_EXEC(self.expandBlock,self);
    }
    else{
        BLOCK_EXEC(self.clickBlock, self);
    }
}

#pragma mark - format data
- (NSMutableAttributedString *)knpFirst:(NSString *)a Second:(NSString *)b {
    if (isEmpty(a) || isEmpty(b)) {
        return nil;
    }
    
    NSString *str = [a stringByAppendingString:b];
    NSRange rangeA = NSMakeRange(0, a.length);
    NSRange rangeB = NSMakeRange(a.length, b.length);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} range:rangeA];
    [attributedText setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]} range:rangeB];
    
    return attributedText;
}
- (CGFloat)percentFromString:(NSString *)percentString {
    percentString = [percentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGFloat percent = [[percentString substringToIndex:[percentString length] - 1] floatValue];
    
    return percent / 100;
}
- (BOOL)clickableWithLevel:(NSInteger)level {
    if (self.knp.children.count > 0
        && (self.knp.data != nil)) {
        return NO;
    }
    return YES;
}

@end

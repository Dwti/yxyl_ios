//
//  QAClassifyAnswerGroupHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyAnswerGroupHeaderView.h"

@interface QAClassifyAnswerGroupHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QAClassifyAnswerGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)updateWithGroupName:(NSString *)name optionsCount:(NSInteger)count {
    self.titleLabel.attributedText = [QAClassifyAnswerGroupHeaderView attrStringForGroupName:name optionsCount:count];
}

+ (NSMutableAttributedString *)attrStringForGroupName:(NSString *)name optionsCount:(NSInteger)count {
    NSString *countStr = [NSString stringWithFormat:@"(%@)",@(count)];
    NSString *totalStr = [NSString stringWithFormat:@"%@ %@",name,countStr];
    NSRange range = [totalStr rangeOfString:countStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Medium size:19] range:range];
    return attrStr;
}

+ (CGSize)sizeForGroupName:(NSString *)name optionsCount:(NSInteger)count {
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.attributedText = [QAClassifyAnswerGroupHeaderView attrStringForGroupName:name optionsCount:count];
    CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-30, 9999)];
    return size;
}

@end

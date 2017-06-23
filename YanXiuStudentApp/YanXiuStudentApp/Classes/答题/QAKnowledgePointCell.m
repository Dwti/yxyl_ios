//
//  QAKnowledgePointCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAKnowledgePointCell.h"

@interface QAKnowledgePointCell ()
@property (nonatomic, strong) UIButton *itemButton;
@end


@implementation QAKnowledgePointCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[UIButton alloc]init];
    self.itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.itemButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.itemButton setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateNormal];
    
    [self addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setKnowledgePoint:(NSString *)knowledgePoint {
    _knowledgePoint = knowledgePoint;
    [self.itemButton setTitle:knowledgePoint forState:UIControlStateNormal];
}

+ (CGSize)sizeForTitle:(NSString *)title {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    return CGSizeMake(ceilf(size.width), 18);
}

@end

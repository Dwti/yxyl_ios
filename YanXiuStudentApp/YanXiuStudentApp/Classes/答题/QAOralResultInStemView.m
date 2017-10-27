//
//  QAOralResultInStemView.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralResultInStemView.h"

@interface QAOralResultInStemView ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation QAOralResultInStemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.leftImageView = [[UIImageView alloc] init];
    [self addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.middleImageView = [[UIImageView alloc] init];
    [self addSubview:self.middleImageView];
    [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.rightImageView = [[UIImageView alloc] init];
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

#pragma mark - setter
- (void)setResultItem:(QAOralResultItem *)resultItem {
    _resultItem = resultItem;
    self.leftImageView.image = [UIImage imageNamed: [resultItem oralResultGrade] == QAOralResultGradeD ? @"页面小赞灰色" : @"页面小赞红色"];
    self.middleImageView.image = [UIImage imageNamed: [resultItem oralResultGrade] == QAOralResultGradeA || [resultItem oralResultGrade] == QAOralResultGradeB ? @"页面小赞红色" : @"页面小赞灰色"];
    self.rightImageView.image = [UIImage imageNamed: [resultItem oralResultGrade] == QAOralResultGradeA ? @"页面小赞红色" : @"页面小赞灰色"];
}

@end

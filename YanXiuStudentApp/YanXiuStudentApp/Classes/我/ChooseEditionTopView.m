//
//  ChooseEditionTopView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ChooseEditionTopView.h"

@interface ChooseEditionTopView ()
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) UIImageView *subjectIconView;
@property (nonatomic, strong) UILabel *subjectNameLabel;
@end

@implementation ChooseEditionTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backGroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发散"]];
    
    self.subjectIconView = [[UIImageView alloc]init];
    
    self.subjectNameLabel = [[UILabel alloc]init];
    self.subjectNameLabel.font = [UIFont boldSystemFontOfSize:40.f];
    self.subjectNameLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.subjectNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.subjectIconView];
    [self.backGroundView addSubview:self.subjectNameLabel];

    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.subjectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33.f * kPhoneWidthRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(175.f * kPhoneWidthRatio, 175.f * kPhoneWidthRatio));
    }];
    [self.subjectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subjectIconView.mas_bottom);
        make.left.right.equalTo(self.subjectIconView);
    }];

}

- (void)setSubject:(GetSubjectRequestItem_subject *)subject {
    _subject = subject;
    self.subjectIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"选择教材-%@",subject.name]];
    self.subjectNameLabel.text = subject.name;
}

@end

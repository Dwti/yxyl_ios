//
//  ExerciseMainSubjectCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExerciseMainSubjectCell.h"

@interface ExerciseMainSubjectCell ()
@property (nonatomic, strong) UIImageView *subjectIconView;
@property (nonatomic, strong) UILabel *subjectNameLabel;
@property (nonatomic, strong) UILabel *editionNameLabel;
@property (nonatomic, assign) BOOL hasChoosedEdition;

@end

@implementation ExerciseMainSubjectCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.subjectIconView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.subjectIconView];
    
    self.subjectNameLabel = [[UILabel alloc]init];
    self.subjectNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.subjectNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.subjectNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.subjectNameLabel];
    
    self.editionNameLabel = [[UILabel alloc]init];
    self.editionNameLabel.font = [UIFont systemFontOfSize:13.f];
    self.editionNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.editionNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.editionNameLabel];
    
    [self.subjectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(86.f, 86.f));
    }];
    [self.subjectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.subjectIconView);
        make.top.mas_equalTo(self.subjectIconView.mas_bottom).offset(7.f);
    }];
    [self.editionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.subjectNameLabel);
        make.top.equalTo(self.subjectNameLabel.mas_bottom).offset(7.f);
    }];
}

- (void)setSubject:(GetSubjectRequestItem_subject *)subject {
    _subject = subject;
    NSString *subjectName = subject.name;
    self.subjectIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"练习-%@",subjectName]];
    self.subjectNameLabel.text = subjectName;
    if (!subject.edition) {
        self.hasChoosedEdition = NO;
    }else {
        self.hasChoosedEdition = YES;
        self.editionNameLabel.text = subject.edition.editionName;
    }
}
@end

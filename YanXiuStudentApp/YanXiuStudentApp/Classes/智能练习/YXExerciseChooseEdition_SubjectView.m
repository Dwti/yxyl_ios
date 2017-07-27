//
//  YXExerciseChooseEdition_SubjectView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/3/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseEdition_SubjectView.h"
@interface YXExerciseChooseEdition_SubjectView ()
@property (nonatomic, strong) UIButton *subjectButton;
@property (nonatomic, strong) UIButton *chooseEditionButton;
@property (nonatomic, strong) UIImageView *subjectIcon;

@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *chooseEditionLabel;

@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@end

@implementation YXExerciseChooseEdition_SubjectView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 145, 125)];
    if (self) {
        [self _setupUI];
        [self _setupMock];
    }
    return self;
}

#pragma mark - public API
- (void)updateWithData:(GetSubjectRequestItem_subject *)subject {
    self.subject = subject;
    self.subjectLabel.text = subject.name;
    if (isEmpty(subject.edition)) {
        self.chooseEditionLabel.text = @"请选择教材";
        [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材"] forState:UIControlStateNormal];
        [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材-按下"] forState:UIControlStateHighlighted];
        self.chooseEditionLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.chooseEditionLabel.layer.shadowOpacity = 1;
        self.chooseEditionLabel.layer.shadowRadius = 0;
    } else {
        self.chooseEditionLabel.text = subject.edition.editionName;
        [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材-不可点"] forState:UIControlStateNormal];
        [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材-不可点"] forState:UIControlStateHighlighted];
        self.chooseEditionLabel.layer.shadowOffset = CGSizeMake(0, 0);
        self.chooseEditionLabel.layer.shadowOpacity = 0;
        self.chooseEditionLabel.layer.shadowRadius = 0;
    }
    
    self.subjectIcon.image = [UIImage imageNamed:[YXSubjectImageHelper smartExerciseImageNameWithType:[subject.subjectID integerValue]]];
}

#pragma mark - private API
- (void)_setupUI {
    self.clipsToBounds = NO;
    // trick 整体为一张
    self.chooseEditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材"] forState:UIControlStateNormal];
    [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材-按下"] forState:UIControlStateHighlighted];
    [self.chooseEditionButton setBackgroundImage:[UIImage imageNamed:@"选择教材-不可点"] forState:UIControlStateDisabled];
    [self addSubview:self.chooseEditionButton];
    [self.chooseEditionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.subjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subjectButton setBackgroundImage:[UIImage imageNamed:@"选择学科"] forState:UIControlStateNormal];
    [self.subjectButton setBackgroundImage:[UIImage imageNamed:@"选择学科-按下"] forState:UIControlStateHighlighted];
    [self addSubview:self.subjectButton];
    [self.subjectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2.5);
        make.left.mas_equalTo(2.5);
        make.right.mas_equalTo(-2.5);
        make.height.mas_equalTo(83);
    }];
    
    self.subjectIcon = [[UIImageView alloc] init];
    [self addSubview:self.subjectIcon];
    [self.subjectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.centerX.mas_equalTo(0);
    }];
    
    self.subjectLabel = [[UILabel alloc] init];
    self.subjectLabel.font = [UIFont boldSystemFontOfSize:20];
    self.subjectLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.subjectLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.subjectLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.subjectLabel.layer.shadowOpacity = 1;
    self.subjectLabel.layer.shadowRadius = 0;
    [self addSubview:self.subjectLabel];
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.centerX.mas_equalTo(0);
    }];
    
    self.chooseEditionLabel = [[UILabel alloc] init];
    self.chooseEditionLabel.font = [UIFont boldSystemFontOfSize:13];
    self.chooseEditionLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.chooseEditionLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.chooseEditionLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.chooseEditionLabel.layer.shadowOpacity = 1;
    self.chooseEditionLabel.layer.shadowRadius = 0;
    [self addSubview:self.chooseEditionLabel];
    [self.chooseEditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-17);
    }];
    
    [self.subjectButton addTarget:self action:@selector(subjectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseEditionButton addTarget:self action:@selector(chooseEditionButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)subjectButtonAction {
    [self.delegate subjectViewSubjectTapped:self];
}

- (void)chooseEditionButtonAction {
    if (isEmpty(self.subject.edition)) {
        [self.delegate subjectViewChooseEditionTapped:self];
    }else {
        [self.delegate subjectViewSubjectTapped:self];
    }
}

#pragma mark - mock
- (void)_setupMock {
    self.subjectIcon.image = [UIImage imageNamed:@"学科icon"];
    self.subjectLabel.text = @"语文";
    self.chooseEditionLabel.text = @"请选择教材";
}

@end

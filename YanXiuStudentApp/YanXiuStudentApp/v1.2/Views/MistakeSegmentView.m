//
//  MistakeSegmentView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeSegmentView.h"

@interface MistakeSegmentView()
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *chapterButton;
@property (nonatomic, strong) UIButton *knpButton;
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake_data *data;
@end

@implementation MistakeSegmentView

- (instancetype)initWithSubject:(GetSubjectMistakeRequestItem_subjectMistake_data *)data {
    if (self = [super init]) {
        self.data = data;
        [self setupUI];
        [self setupTopButtons];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.allButton = [[UIButton alloc] init];
    self.allButton.tag = 0;
    [self.allButton setImage:[UIImage imageNamed:@"全部"] forState:UIControlStateNormal];
    [self.allButton setImage:[UIImage imageNamed:@"全部"] forState:UIControlStateHighlighted];
    [self.allButton setBackgroundColor:[UIColor colorWithHexString:@"006666"]];
    [self.allButton addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.chapterButton = [[UIButton alloc] init];
    self.chapterButton.tag = 1;
    [self.chapterButton setImage:[UIImage imageNamed:@"章节"] forState:UIControlStateNormal];
    [self.chapterButton setImage:[UIImage imageNamed:@"章节"] forState:UIControlStateHighlighted];
    [self.chapterButton addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.knpButton = [[UIButton alloc] init];
    self.knpButton.tag = 2;
    [self.knpButton setImage:[UIImage imageNamed:@"知识点"] forState:UIControlStateNormal];
    [self.knpButton setImage:[UIImage imageNamed:@"知识点"] forState:UIControlStateHighlighted];
    [self.knpButton addTarget:self action:@selector(topButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)topButtonTapped:(UIButton *)sender {
    [self.allButton setBackgroundColor:[UIColor colorWithHexString:@"008080"]];
    [self.chapterButton setBackgroundColor:[UIColor colorWithHexString:@"008080"]];
    [self.knpButton setBackgroundColor:[UIColor colorWithHexString:@"008080"]];
    [sender setBackgroundColor:[UIColor colorWithHexString:@"006666"]];
    
    if (self.buttonTappedBlock) {
        self.buttonTappedBlock(sender);
    }
}

- (void)setupTopButtons {
    CGFloat buttonWidth = 0;
    
    if ([self isShowChapterButton] && [self isShowKnpButton]) {
        [self addSubview:self.chapterButton];
        [self addSubview:self.knpButton];
        
        buttonWidth = [UIScreen mainScreen].bounds.size.width / 3;
        [self.chapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(buttonWidth);
            make.width.mas_equalTo(buttonWidth);
        }];
        [self.knpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(buttonWidth * 2);
            make.width.mas_equalTo(buttonWidth);
        }];
    } else if ([self isShowChapterButton] && ![self isShowKnpButton]) {
        [self addSubview:self.chapterButton];
        
        buttonWidth = [UIScreen mainScreen].bounds.size.width / 2;
        [self.chapterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(buttonWidth);
            make.width.mas_equalTo(buttonWidth);
        }];
    } else {
        buttonWidth = [UIScreen mainScreen].bounds.size.width;
    }
    
    [self addSubview:self.allButton];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(buttonWidth);
    }];
}

- (BOOL)isShowChapterButton {
    if ([self.data.chapterTag isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

- (BOOL)isShowKnpButton {
    if ([self.data.pointTag isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}


@end

//
//  QAAnswerSheetCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerSheetCell.h"
#import "UIImage+YXImage.h"
#import "QAQuestionIndexDetailView.h"
#import "UIButton+WaveHighlight.h"

NSString * const kQASelectedQuestionNotification = @"kQASelectedQuestionNotification";
NSString * const kQASelectedQuestionKey = @"kQASelectedQuestionKey";

@interface QAAnswerSheetCell ()
@property (nonatomic, strong) UIButton *itemButton;
@property (nonatomic, strong) QAQuestionIndexDetailView *questionIndexDetailView;
@end


@implementation QAAnswerSheetCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.itemButton.layer.cornerRadius = 24;
    self.itemButton.clipsToBounds = YES;
    self.itemButton.isWaveHighlight = YES;
    self.itemButton.titleLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:21];
    [self.itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.itemButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemButton addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.itemButton addTarget:self action:@selector(btnTouchOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.contentView addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.questionIndexDetailView = [[QAQuestionIndexDetailView alloc]init];
    self.questionIndexDetailView.userInteractionEnabled = NO;
}

- (void)setHasWrote:(BOOL)hasWrote {
    _hasWrote = hasWrote;
    if (hasWrote) {
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"已做题号"] forState:UIControlStateNormal];
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"已做题号点击态"] forState:UIControlStateHighlighted];
        [self.itemButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
        self.questionIndexDetailView.colorString = @"89e00d";
    }else {
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"未做题号"] forState:UIControlStateNormal];
        [self.itemButton setBackgroundImage:[UIImage imageNamed:@"未做题号点击态"] forState:UIControlStateHighlighted];
        [self.itemButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        self.questionIndexDetailView.colorString = @"999999";
    }
}

- (void)setItem:(QAQuestion *)item {
    _item = item;
    NSString *title = item.position.indexDetailString;
    if ([title containsString:@"-"]) {
        NSArray *array = [title componentsSeparatedByString:@"-"];
        NSString *questionString = array.firstObject;
        NSString *detailString = array.lastObject;
        [self.itemButton addSubview:self.questionIndexDetailView];
        [self.questionIndexDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.questionIndexDetailView.indexString = questionString;
        self.questionIndexDetailView.detailString = detailString;
    }else {
        [self.questionIndexDetailView removeFromSuperview];
        
        [self.itemButton setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - btnAction
- (void)btnAction:(UIButton *)button {
    if (self.questionIndexDetailView.superview) {
        if (self.hasWrote) {
            self.questionIndexDetailView.colorString = @"89e00d";
        }else {
            self.questionIndexDetailView.colorString = @"999999";
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kQASelectedQuestionNotification object:nil userInfo:@{kQASelectedQuestionKey:self.item}];
}

- (void)btnTouchDown:(UIButton *)sender {
    if (self.questionIndexDetailView.superview) {
        self.questionIndexDetailView.colorString = @"ffffff";
    }
}

- (void)btnTouchOutside:(UIButton *)sender {
    if (self.questionIndexDetailView.superview) {
        if (self.hasWrote) {
            self.questionIndexDetailView.colorString = @"89e00d";
        }else {
            self.questionIndexDetailView.colorString = @"999999";
        }
    }
}



@end

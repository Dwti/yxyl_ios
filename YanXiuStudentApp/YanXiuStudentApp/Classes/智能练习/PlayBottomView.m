//
//  PlayBottomView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PlayBottomView.h"

@interface PlayBottomView()
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation PlayBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-正常态"] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[UIImage imageNamed:@"暂停按钮-点击态"] forState:UIControlStateHighlighted];
    [self addSubview:self.playPauseButton];
    
    self.rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rotateButton];
    self.slideProgressControl = [[SlideProgressControl alloc] init];
    [self addSubview:self.slideProgressControl];
    
    self.definitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.definitionButton.hidden = YES;
    [self.definitionButton setTitleColor:[UIColor colorWithHexString:@"#868686"] forState:UIControlStateNormal];
    self.definitionButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.definitionButton];
}

- (void)setupLayout{
    [self.playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(5.0f);
    }];
    
    [self.rotateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0f, 30.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15.0f + 7.0f);
    }];
    
    [self.slideProgressControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playPauseButton.mas_right).offset(10.0f);
        make.right.equalTo(self.rotateButton.mas_left).offset(15.0f);
        make.top.bottom.mas_equalTo(@0);
    }];
    [self.slideProgressControl updateUI];
    
    
    [self.definitionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(45.0f);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
}

#pragma mark - set
- (void)setIsFullscreen:(BOOL)isFullscreen{
    _isFullscreen = isFullscreen;
    if (isFullscreen) {
        [self.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateNormal];
        [self.rotateButton setImage:[UIImage imageNamed:@"放大按钮"] forState:UIControlStateHighlighted];

        self.definitionButton.hidden = !self.isShowDefinition;
        self.rotateButton.hidden = self.isShowDefinition;
    }else{
        [self.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateNormal];
        [self.rotateButton setImage:[UIImage imageNamed:@"缩小按钮-"] forState:UIControlStateHighlighted];

        self.definitionButton.hidden = YES;
        self.rotateButton.hidden = NO;
    }
}
@end

//
//  VideoPromptView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VideoPromptView.h"
#import "UIButton+WaveHighlight.h"

@interface VideoPromptView ()
@property(nonatomic, strong) UIImageView *previewImageView;
@property(nonatomic, strong) UIButton *palyButton;
@property(nonatomic, strong) UILabel *topNoticeLabel;
@property(nonatomic, strong) UILabel *bottomNoticeLabel;
@property(nonatomic, strong) UIButton *skipButton;

@property(nonatomic, copy) PlayVideoBlock playBlock;
@property(nonatomic, copy) SkipVideoBlock skipBlock;
@end

@implementation VideoPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 6.f;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    
    self.previewImageView = [[UIImageView alloc]init];
    self.previewImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.previewImageView];
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(182 * kPhoneWidthRatio);
    }];
    
    self.palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.palyButton setImage:[UIImage imageNamed:@"播放视频按钮-正常态-"] forState:UIControlStateNormal];
    [self.palyButton setImage:[UIImage imageNamed:@"播放视频按钮-点击态"] forState:UIControlStateHighlighted];
    self.previewImageView.userInteractionEnabled = YES;
    [self.palyButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.previewImageView addSubview:self.palyButton];
    [self.palyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70.f, 70.f));
    }];

    self.topNoticeLabel = [[UILabel alloc]init];
    self.topNoticeLabel.font = [UIFont boldSystemFontOfSize:19.f];
    self.topNoticeLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.topNoticeLabel.numberOfLines = 0;
    self.topNoticeLabel.text = @"请先看一段视频\n再做后面的题目";
    [self addSubview:self.topNoticeLabel];
    [self.topNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.previewImageView.mas_bottom).offset(27 * kPhoneWidthRatio);
        make.centerX.mas_equalTo(0);
    }];
    
    self.bottomNoticeLabel = [[UILabel alloc]init];
    self.bottomNoticeLabel.font = [UIFont systemFontOfSize:13.f];
    self.bottomNoticeLabel.text = @"答题中也可以继续观看视频";
    self.bottomNoticeLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    [self addSubview:self.bottomNoticeLabel];
    [self.bottomNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.topNoticeLabel.mas_bottom).offset(15 * kPhoneWidthRatio);
    }];

    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.layer.cornerRadius = 6.0f;
    self.skipButton.clipsToBounds = YES;
    self.skipButton.isWaveHighlight = YES;
    self.skipButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.skipButton setTitle:@"跳过,开始作答" forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
    [self.skipButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30.f * kPhoneWidthRatio);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(250 * kPhoneWidthRatio, 50 * kPhoneWidthRatio));
    }];
}

- (void)playAction:(UIButton *)sender {
    BLOCK_EXEC(self.playBlock);
}

- (void)skipButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.skipBlock);
}

- (void)setPlayVideoBlock:(PlayVideoBlock)block {
    self.playBlock = block;
}

- (void)setSkipVideoBlock:(SkipVideoBlock)block {
    self.skipBlock = block;
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.previewImageView.image = coverImage;
}
@end

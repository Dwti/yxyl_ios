//
//  VideoThumbView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VideoThumbView.h"

@interface VideoThumbView()
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *thumbFoldButton;
@property(nonatomic, copy) VideoThumbViewPlaydBlock playBlock;
@property(nonatomic, copy) VideoThumbViewFoldBlock foldBlock;
@end

@implementation VideoThumbView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.backgroundColor = [UIColor blackColor];
    self.thumbImageView.userInteractionEnabled = YES;
    [self addSubview:self.thumbImageView];
    
    self.placeholderImageView = [[UIImageView alloc] init];
    self.placeholderImageView.image = [UIImage imageNamed:@"视频未读取过来的默认图片"];
    [self.thumbImageView addSubview:self.placeholderImageView];
    
    self.playButton = [[UIButton alloc] init];
    [self.playButton setImage:[UIImage imageNamed:@"播放视频按钮-正常态-"]
                     forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"播放视频按钮-点击态"]
                     forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbImageView addSubview:self.playButton];
    
    self.thumbFoldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.thumbFoldButton setImage:[UIImage imageNamed:@"视频收起按钮正常态-"] forState:UIControlStateNormal];
    [self.thumbFoldButton setImage:[UIImage imageNamed:@"视频收起按钮点击态"] forState:UIControlStateHighlighted];
    [self.thumbFoldButton addTarget:self action:@selector(foldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.thumbFoldButton];
}

- (void)setupLayout {
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(180.0f, 180.0f));
        make.center.equalTo(self.thumbImageView);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.thumbImageView);
        make.width.height.mas_offset(50.0f);
    }];
    [self.thumbFoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
}

- (void)playButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.playBlock);
}

- (void)foldButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.foldBlock);
}

- (void)setVideoThumbViewPlaydBlock:(VideoThumbViewPlaydBlock)block {
    self.playBlock = block;
}

- (void)setVideoThumbViewFoldBlock:(VideoThumbViewFoldBlock)block {
    self.foldBlock = block;
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    WEAK_SELF
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        if (!error) {
            self.placeholderImageView.hidden = YES;
        }
    }];
}
@end

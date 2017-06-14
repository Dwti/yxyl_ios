//
//  QAPhotoSelectionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoSelectionCell.h"
#import "UIButton+WaveHighlight.h"

@implementation QAPhotoItem

@end

@interface QAPhotoSelectionCell()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation QAPhotoSelectionCell
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.photoImageView = [[UIImageView alloc]init];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIButton *topButton = [[UIButton alloc]init];
    topButton.clipsToBounds = YES;
    topButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [topButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"8cde2e"]] forState:UIControlStateHighlighted];
    [topButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    topButton.isWaveHighlight = YES;
    [self.contentView addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.topButton = topButton;
}

- (void)btnAction {
    BLOCK_EXEC(self.clickBlock);
}

- (void)setPhotoItem:(QAPhotoItem *)photoItem {
    _photoItem = photoItem;
    [self updateWithImage:photoItem.image];
    if (!photoItem.image) {
        CGSize size = CGSizeMake(120, 120);
        WEAK_SELF
        [[PHCachingImageManager defaultManager] requestImageForAsset:photoItem.asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            STRONG_SELF
            [self handleResultImage:result];
        }];
    }
}

- (void)updateWithImage:(UIImage *)image {
    self.photoImageView.image = image;
    [self.topButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.topButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"8cde2e"]] forState:UIControlStateHighlighted];
}

- (void)handleResultImage:(UIImage *)resultImage {
    CGSize size = CGSizeMake(120, 120);
    __block UIImage *image = resultImage;
    [self performBackgroundTaskWithBlock:^{
        image = [resultImage nyx_aspectFillImageWithSize:size];
    } completeBlock:^{
        self.photoItem.image = image;
        [self updateWithImage:image];
    }];
}

@end

//
//  PhotoCollectionViewCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/3/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoAssetUtils.h"

@interface PhotoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) YXPhotoModel *photoModel;
@end

@implementation PhotoCollectionViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoView.layer.cornerRadius = 6;
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    self.photoView.layer.cornerRadius = 6;
    self.photoView.clipsToBounds = YES;
    
    self.selectButton  = [[UIButton alloc] initWithFrame:CGRectZero];
    self.selectButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.selectButton];
    UIImage *dImage = [[UIImage imageNamed:@"缩略图默认边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *sImage = [[UIImage imageNamed:@"缩略图选中状态边框"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    dImage = [UIImage imageNamed:@"缩略图默认边框"];
    sImage = [UIImage imageNamed:@"缩略图选中状态边框"];
    [self.selectButton setBackgroundImage:dImage forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage
     :sImage forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setPhotoModel:(YXPhotoModel *)photoModel {
    _photoModel = photoModel;
    if (photoModel) {
        self.photoView.image = photoModel.thumbImage;
        self.photoView.layer.cornerRadius = 6;
        [self.photoView setNeedsDisplay];
        self.selectButton.selected = _photoModel.isSelect;
    }
}

- (void)setPhotoAsset:(ALAsset *)photoAsset {
    _photoAsset = photoAsset;
    __block YXPhotoModel *model = nil;
    WEAK_SELF
    [self performBackgroundTaskWithBlock:^{
        model = [PhotoAssetUtils photoModelFromAsset:photoAsset];
        if (!model.thumbImage) {
            UIImage *fullScreenImage = [PhotoAssetUtils imageFromAsset:model.photoAsset type:PhotoAssetSizeType_ScreenSize];
            UIImage *thumbnailImage = [self scaleImage:fullScreenImage];
            model.thumbImage = thumbnailImage;
        }
    } completeBlock:^{
        STRONG_SELF
        if (model.photoAsset == self.photoAsset) {
            self.photoModel = model;
        }
    }];
}

- (UIImage *)scaleImage:(UIImage *)img {
    CGFloat targetSize = self.width;
    CGFloat imgWidth = img.size.width;
    CGFloat imgHeight = img.size.height;
    CGFloat widthFactor = targetSize / imgWidth;
    CGFloat heightFactor = targetSize / imgHeight;
    CGFloat factor = MAX(widthFactor, heightFactor);
    return [img scaleToSize:CGSizeMake(imgWidth * factor, imgHeight * factor)];
}

- (void)selectButtonClicked:(UIButton *)sender {
    if (self.selectHandle) {
        self.selectHandle([PhotoAssetUtils imageFromAsset:self.photoModel.photoAsset type:PhotoAssetSizeType_ScreenSize]);
    }
}
@end

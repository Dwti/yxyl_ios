//
//  QACameraOverlayView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QACameraOverlayView.h"

@interface QACameraOverlayView()
@property (nonatomic, strong) UIButton *albumButton;
@end

@implementation QACameraOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [[UIColor colorWithHexString:@"cccccc"]colorWithAlphaComponent:0.5];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(123);
    }];
    UIButton *albumButton = [[UIButton alloc]init];
    albumButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    albumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    albumButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [albumButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(albumAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:albumButton];
    [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.mas_equalTo(0);
    }];
    self.albumButton = albumButton;
    
    UIView *cameraBottomView = [[UIView alloc]init];
    cameraBottomView.backgroundColor = [UIColor whiteColor];
    cameraBottomView.layer.cornerRadius = 33;
    cameraBottomView.layer.borderWidth = 5;
    cameraBottomView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    cameraBottomView.clipsToBounds = YES;
    [containerView addSubview:cameraBottomView];
    [cameraBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    UIButton *cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.layer.cornerRadius = 25;
    cameraButton.clipsToBounds = YES;
    [cameraBottomView addSubview:cameraButton];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    UIButton *exitButton = [[UIButton alloc]init];
    [exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:exitButton];
    [exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-53*kPhoneWidthRatio);
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.centerY.mas_equalTo(0);
    }];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized) {
        PHFetchResult *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
        if (results.count > 0) {
            PHAssetCollection *collection = results.firstObject;
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            options.fetchLimit = 1;
            PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            if (assetsFetchResults.count > 0) {
                PHAsset *asset = assetsFetchResults[0];
                CGSize size = CGSizeMake(60, 60);
                WEAK_SELF
                [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    STRONG_SELF
                    [self handleResultImage:result];
                }];
            }
        }
    }
}

- (void)handleResultImage:(UIImage *)resultImage {
    CGSize size = CGSizeMake(60, 60);
    __block UIImage *image = resultImage;
    [self performBackgroundTaskWithBlock:^{
        image = [resultImage nyx_aspectFillImageWithSize:size];
    } completeBlock:^{
        [self.albumButton setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

- (void)albumAction {
    BLOCK_EXEC(self.albumBlock);
}

- (void)cameraAction {
    BLOCK_EXEC(self.cameraBlock);
}

- (void)exitAction {
    BLOCK_EXEC(self.exitBlock);
}

@end

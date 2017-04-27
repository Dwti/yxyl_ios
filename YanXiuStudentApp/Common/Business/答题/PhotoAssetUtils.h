//
//  PhotoAssetUtils.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, PhotoAssetSizeType) {
    PhotoAssetSizeType_Thumbnail,
    PhotoAssetSizeType_ScreenSize,
    PhotoAssetSizeType_Full
};

@interface AssetGroupInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImage *thumbnail;
@end

//////////////////////////////////////////
@interface PhotoAssetUtils : NSObject
+ (NSArray<__kindof YXPhotoModel *> *)allPhotosFromAssetGroup:(ALAssetsGroup *)assetGroup;
+ (YXPhotoModel *)photoModelFromAsset:(ALAsset *)asset;
+ (UIImage *)imageFromAsset:(ALAsset *)asset type:(PhotoAssetSizeType)aType;
+ (AssetGroupInfo *)assetGroupInfoFromGroup:(ALAssetsGroup *)group;
@end

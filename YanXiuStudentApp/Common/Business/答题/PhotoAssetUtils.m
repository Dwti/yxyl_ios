//
//  PhotoAssetUtils.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PhotoAssetUtils.h"
#import "PhotoAssetManager.h"

@implementation AssetGroupInfo
@end

@implementation PhotoAssetUtils

+ (NSArray<__kindof YXPhotoModel *> *)allPhotosFromAssetGroup:(ALAssetsGroup *)assetGroup {
    NSMutableArray *array = [NSMutableArray array];
    [[PhotoAssetManager shareManager] getPhotoListOfGroup:assetGroup result:^(NSArray *resultArray) {
        [resultArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
            YXPhotoModel *photoModel = [self photoModelFromAsset:obj];
            [array insertObject:photoModel atIndex:0];
        }];
    }];
    return array;
}

+ (YXPhotoModel *)photoModelFromAsset:(ALAsset *)asset {
    NSURL * assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    YXPhotoModel *photoModel = [[YXPhotoModel alloc] initWithURL:assetURL];
    photoModel.thumbImage = [self imageFromAsset:asset type:PhotoAssetSizeType_Thumbnail];
    photoModel.photoAsset = asset;
    return photoModel;
}

+ (UIImage *)imageFromAsset:(ALAsset *)asset type:(PhotoAssetSizeType)aType {
    CGImageRef iRef = nil;
    
    if (aType == PhotoAssetSizeType_Thumbnail)
        iRef = [asset thumbnail];
    else if (aType == PhotoAssetSizeType_ScreenSize)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (aType == PhotoAssetSizeType_Full)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
        
        CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        
        NSError *error = nil;
        NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                     inputImageExtent:image.extent
                                                                error:&error];
        if (error) {
            NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
        }
        
        for (CIFilter *filter in filterArray) {
            [filter setValue:image forKey:kCIInputImageKey];
            image = [filter outputImage];
        }
        
        UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        return iImage;
    }
    
    return [UIImage imageWithCGImage:iRef];
}

+ (AssetGroupInfo *)assetGroupInfoFromGroup:(ALAssetsGroup *)group {
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [group numberOfAssets];
    UIImage *thumbnail = [UIImage imageWithCGImage:[group posterImage]];
    
    AssetGroupInfo *info = [[AssetGroupInfo alloc]init];
    info.name = name;
    info.count = count;
    info.thumbnail = thumbnail;
    return info;
}

@end

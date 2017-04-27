//
//  YXPhotoManager.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/18.
//  Copyright © 2015年 wd. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, YXPhotoAssetType) {
    YXPhotoAssetType_Thumbnail,
    YXPhotoAssetType_ScreenSize,
    YXPhotoAssetType_Full
};

#define PHOTOMANAGER    [YXPhotoManager shareManager]

@interface YXPhotoManager : NSObject

/**
 *  已经选择的相片array，，全局的。和clearData配合使用。object类型为YXPhotoModel.
 */
@property(nonatomic, strong) NSMutableArray * photosArray;

+ (instancetype)shareManager;
/**
 *  get UIImage from Asset with type
 *
 *  @param asset ALAsset
 *  @param nType YXPhotoAssetType
 *
 *  @return UIImage
 */
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(YXPhotoAssetType)aType;
- (void)clearData;
- (NSInteger )canSelectPhotoCount;
@end

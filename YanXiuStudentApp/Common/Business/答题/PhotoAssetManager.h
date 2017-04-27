//
//  PhotoAssetManager.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define PHOTOASSETMANAGER    [PhotoAssetManager shareManager]

@interface PhotoAssetManager : NSObject

+ (instancetype)shareManager;

/**
 *  get album list from asset
 *
 *  @param result ALAssetsGroup
 */
- (void)getGroupList:(void (^)(NSArray * resultArray))resultBlock;
/**
 *  get photos from specific album with ALAssetsGroup object
 *
 *  @param alGroup ALAssetsGroup
 *  @param result  ALAsset
 */
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray * resultArray))resultBlock;
/**
 *  get photos from specific album with index of album array
 *
 *  @param nGroupIndex NSInteger
 *  @param result      ALAsset
 */
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray * resultArray))resultBlock;
- (void)clearData;

@end

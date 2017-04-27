//
//  PhotoAssetManager.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import "PhotoAssetManager.h"

@interface PhotoAssetManager ()

/**
 *  相册库，获取所有相册
 */
@property (nonatomic, strong)   ALAssetsLibrary			*assetsLibrary;
/**
 *  某一个相册中得所有图片
 */
@property (nonatomic, strong)   NSMutableArray          *assetPhotos;
/**
 *  所有相册Groups
 */
@property (nonatomic, strong)   NSMutableArray          *assetGroups;

@end
@implementation PhotoAssetManager
+ (instancetype)shareManager
{
    static PhotoAssetManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PhotoAssetManager alloc] init];
        [_sharedInstance initAsset];
    });
    
    return _sharedInstance;

}
/**
 *  初始图片库
 */
- (void)initAsset
{
    if (_assetsLibrary == nil)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        NSString *strVersion = [[UIDevice alloc] systemVersion];
        if ([strVersion compare:@"5"] >= 0)
            [_assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            }];
    }
}

- (void)getGroupList:(void (^)(NSArray * resultArray))resultBlock
{
    [self initAsset];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        if (group == nil){
            resultBlock(_assetGroups);
            return;
        }
        [_assetGroups insertObject:group atIndex:0];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", [error description]);
    };
    
    _assetGroups = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray * resultArray))resultBlock
{
    [self initAsset];
    
    _assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [alGroup enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        if(alPhoto == nil){
            resultBlock(_assetPhotos);
            return;
        }
        [_assetPhotos addObject:alPhoto];
    }];

}

- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray * resultArray))resultBlock
{
    [self getPhotoListOfGroup:_assetGroups[nGroupIndex] result:^(NSArray *aResult) {
        resultBlock(_assetPhotos);
        
    }];
}
- (void)clearData
{
    [self.assetGroups removeAllObjects];
    self.assetGroups = nil;
    [self.assetPhotos removeAllObjects];
    self.assetPhotos = nil;
}
@end

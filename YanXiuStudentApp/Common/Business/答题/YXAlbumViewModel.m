//
//  YXAlbumViewModel.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import "YXAlbumViewModel.h"
#import "PhotoAssetManager.h"
#import "YXPhotoManager.h"
#import "YXPhotoModel.h"
@interface YXAlbumViewModel ()

@property (nonatomic, strong) PhotoAssetManager* assetManager;
@end
@implementation YXAlbumViewModel
- (instancetype) init
{
    self = [super init];
    if (self) {
        _albumListArray = [NSArray array];
        _currentPhotoListArray = [NSArray array];
//        _assetManager = PHOTOASSETMANAGER;
        _selectPhotoArray = [NSArray array];
        [self setupCommands];
        [self setupRAC];
    }
    return self;
}

- (void) setupCommands
{

}
- (void)setupRAC
{
    
}
- (void)gotoGetAlbumListArray
{
    @weakify(self);
    [_assetManager getGroupList:^(NSArray * resultArray) {
        @strongify(self);
        self.albumListArray = resultArray;
    }];
}
- (void)pushToPhotoListViewByIndex:(NSInteger)index
{
    @weakify(self);
    NSLog(@"1111111");
    [_assetManager getPhotoListOfGroupByIndex:index result:^(NSArray *resultArray) {
        @strongify(self);
        NSMutableArray * array = [NSMutableArray array];
        [resultArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
#if 0
            YXPhotoModel * photoModel = [[YXPhotoModel alloc] initWithImage:[PHOTOMANAGER getImageFromAsset:obj type:YXPhotoAssetType_Thumbnail]];
#endif
            NSURL * assetURL = [obj valueForProperty:ALAssetPropertyAssetURL];
            YXPhotoModel * photoModel = [[YXPhotoModel alloc] initWithURL:assetURL];
            photoModel.thumbImage = [PHOTOMANAGER getImageFromAsset:obj type:YXPhotoAssetType_Thumbnail];
            [array insertObject:photoModel atIndex:0];
        }];
        self.currentPhotoListArray = array;
    }];
    NSLog(@"22222");
}
- (NSInteger)albumListArrayCount
{
    return [self.albumListArray count];
}
- (NSDictionary *)getAlbumInfo:(NSInteger)nIndex
{
    ALAssetsGroup *group = self.albumListArray[nIndex];
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    NSInteger count = [group numberOfAssets];
    UIImage *thumbnail = [UIImage imageWithCGImage:[group posterImage]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"name"];
    [dic setValue:@(count) forKey:@"count"];
    [dic setValue:thumbnail forKey:@"thumbnail"];
    return dic;
}
- (NSInteger)getCurrentPhotoListArrayCount
{
    return [self.currentPhotoListArray count];
}
- (UIImage *)getPhotoImage:(NSInteger)nIndex
{
    YXPhotoModel * model = self.currentPhotoListArray[nIndex];
    return model.thumbImage;
}
- (BOOL)isCanSelect
{
    return [self canSelectPhotoCount] > [self selectCount];
}
- (NSInteger)selectCount
{
    __block NSInteger selectNumbers = 0;
    [self.currentPhotoListArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        YXPhotoModel * photoModel = obj;
        if (photoModel.isSelect) {
            selectNumbers ++;
        }
    }];
    return selectNumbers;
}
- (NSInteger )canSelectPhotoCount
{
    return (9 - [self.selectPhotoArray count]);
}
- (void)selectPhotoArrayAddObjectWithArray:(NSMutableArray *)photosArray
{
    if (photosArray) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:_selectPhotoArray];
        [photosArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
            YXPhotoModel * model = obj;
            if (model.isSelect) {
                [model loadUnderlyingImageAndNotify];
                [array addObject:obj];
            }
        }];
        self.selectPhotoArray = array;
    }
}
- (void)selectPhotoArrayAddObject:(YXPhotoModel *)model
{
    if (model) {
        [model loadUnderlyingImageAndNotify];
        NSMutableArray * array = [NSMutableArray arrayWithArray:_selectPhotoArray];
        [array addObject:model];
        self.selectPhotoArray = array;
    }
}
- (void)selectPhotoArrayDelegateObject:(YXPhotoModel *)model
{
    if (model) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:_selectPhotoArray];
        [array removeObject:model];
        self.selectPhotoArray = array;
    }
}
@end

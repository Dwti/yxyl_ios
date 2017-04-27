//
//  YXAlbumViewModel.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXPhotoModel;
@interface YXAlbumViewModel : NSObject
@property (nonatomic, strong) NSArray * albumListArray;
@property (nonatomic, strong) NSArray * currentPhotoListArray;
@property (nonatomic, strong) NSArray * selectPhotoArray;
@property (nonatomic, assign) NSUInteger currentPositonPhoto;

- (void)gotoGetAlbumListArray;
- (void)pushToPhotoListViewByIndex:(NSInteger)index;
- (NSInteger)albumListArrayCount;
/**
 *  get album info
 *
 *  @param nIndex albumListArray position
 *
 *  @return return value description
    value: album Name              key:@"name"
    value: album photos count      key:@"count"
    value: album thumbnail         key:@"thumbnail"
 */
- (NSDictionary *)getAlbumInfo:(NSInteger)nIndex;

- (NSInteger)getCurrentPhotoListArrayCount;
- (UIImage *)getPhotoImage:(NSInteger)nIndex;
- (BOOL)isCanSelect;
- (NSInteger)selectCount;
- (NSInteger )canSelectPhotoCount;
- (void)selectPhotoArrayAddObjectWithArray:(NSMutableArray *)photosArray;
- (void)selectPhotoArrayAddObject:(YXPhotoModel *)model;
- (void)selectPhotoArrayDelegateObject:(YXPhotoModel *)model;
@end

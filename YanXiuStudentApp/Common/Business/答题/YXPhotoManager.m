//
//  YXPhotoManager.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/18.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXPhotoManager.h"
#import "YXPhotoModel.h"

@implementation YXPhotoManager
+ (instancetype)shareManager
{
    static YXPhotoManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YXPhotoManager alloc] init];
    });
    return _sharedInstance;
}
- (instancetype)init
{
    if (self = [super init]) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(YXPhotoAssetType)aType
{
    CGImageRef iRef = nil;
    
    if (aType == YXPhotoAssetType_Thumbnail)
        iRef = [asset thumbnail];
    else if (aType == YXPhotoAssetType_ScreenSize)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (aType == YXPhotoAssetType_Full)
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
- (void)clearData
{
    [self.photosArray removeAllObjects];
}
- (NSInteger )canSelectPhotoCount
{
    return (9 - [self.photosArray count]);
}
- (void)setPhotosArray:(NSMutableArray *)photosArray
{
    if (photosArray) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:_photosArray];
        [photosArray enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
            YXPhotoModel * model = obj;
            if (model.isSelect) {
                [array addObject:obj];
            }
        }];
        _photosArray = array;
    }
}
@end

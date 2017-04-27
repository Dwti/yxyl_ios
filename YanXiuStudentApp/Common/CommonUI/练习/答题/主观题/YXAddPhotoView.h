//
//  YXAddPhotoView.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface YXAddPhotoView : UIView

@property(nonatomic, assign) BOOL addEnable;
@property(nonatomic, copy) void (^photoHandle)(NSInteger nIndex);
@property(nonatomic, copy) void (^addHandle)();
@property (nonatomic, copy) void (^adjustAddButton) (UIButton *btn);

- (instancetype)initWithFrame:(CGRect)frame addEnable:(BOOL)enable;
- (instancetype)initWithFrame:(CGRect)frame
            photoNumberPerRow:(NSInteger)photoNumber
                     maxWidth:(CGFloat)maxWidth
                    addEnable:(BOOL)enable;
- (void)reloadWithPhotosArray:(NSArray *)photosArray; //photosArray "YXPhoto"
- (CGFloat)getHight;

@end

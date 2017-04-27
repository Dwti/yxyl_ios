//
//  YXStarRateView.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/24.
//  Copyright © 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXStarRateView : UIView
/**
 *  得分值，范围为0--1，默认为1
 */
@property (nonatomic, assign) CGFloat scorePercent;
/**
 *  是否允许动画，默认为NO
 */
@property (nonatomic, assign) BOOL canAnimation;
/**
 *  评分时是否允许不是整星，默认为NO
 */
@property (nonatomic, assign) BOOL allowIncompleteStar;

/**
 *  init方法
 *
 *  @param frame frame
 *  @param count 星星的个数
 *  @param canTap 能否可操作
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)count canTap:(BOOL)canTap;

- (void)updateWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage;
@end

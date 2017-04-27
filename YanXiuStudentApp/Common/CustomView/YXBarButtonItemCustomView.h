//
//  YXBarButtonItemCustomView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/30.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  导航栏左右两端CustomView
 */
@interface YXBarButtonItemCustomView : UIView

@property (nonatomic, readonly) UIButton *button;

- (void)setButtonTitle:(NSString *)title
                 image:(UIImage *)image
      highLightedImage:(UIImage *)highLightedImage
               isRight:(BOOL)isRight;

@end

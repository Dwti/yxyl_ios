//
//  HeadImagePickerOptionItemView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImagePickerOptionItemView : UIView
@property (nonatomic, strong) void(^actionBlock)(void);
- (void)updateWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title;
@end

//
//  VideoPromptView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayVideoBlock) (void);
typedef void(^SkipVideoBlock) (void);

@interface VideoPromptView : UIView
@property(nonatomic, copy) NSString *coverImage;

- (void)setPlayVideoBlock:(PlayVideoBlock)block;
- (void)setSkipVideoBlock:(SkipVideoBlock)block;
@end

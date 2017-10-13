//
//  VideoThumbView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VideoThumbViewPlaydBlock)(void);
typedef void (^VideoThumbViewFoldBlock)(void);
@interface VideoThumbView : UIView

@property(nonatomic, copy) NSString *imageUrl;
- (void)setVideoThumbViewPlaydBlock:(VideoThumbViewPlaydBlock)block;
- (void)setVideoThumbViewFoldBlock:(VideoThumbViewFoldBlock)block;
@end

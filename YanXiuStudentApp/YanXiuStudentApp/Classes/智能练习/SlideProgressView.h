//
//  SlideProgressView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideProgressView : UIView
@property (nonatomic, strong) UIView *wholeProgressView;
@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat bufferProgress;
@end

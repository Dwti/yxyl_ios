//
//  QAConnectOptionInfo.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectOptionInfo.h"

@implementation QAConnectTwinOptionInfo
@end


@implementation QAConnectOptionInfo
+ (UIImage *)imageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

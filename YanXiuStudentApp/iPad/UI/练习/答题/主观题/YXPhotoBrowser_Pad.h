//
//  YXPhotoBrowser_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface YXPhotoBrowser_Pad : MWPhotoBrowser
@property (nonatomic, copy) void (^deleteHandle)();
/**
 *  是否隐藏删除按钮
 *
 *  @param hidden BOOL
 */
- (void)hiddenRightBarButtonItem:(BOOL)hidden;
@end

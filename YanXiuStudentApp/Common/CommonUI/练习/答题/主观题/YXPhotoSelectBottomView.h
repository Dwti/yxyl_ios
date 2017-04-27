//
//  YXPhotoSelectBottomView.h
//  YanXiuStudentApp
//
//  Created by wd on 15/9/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXPhotoSelectBottomView : UIView
@property(nonatomic, copy) void (^doneHandle)();
- (void)reloadTitleWithInteger:(NSInteger)count;
@end

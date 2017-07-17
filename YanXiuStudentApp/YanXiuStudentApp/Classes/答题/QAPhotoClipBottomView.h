//
//  QAPhotoClipBottomView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoClipBottomView : UIView
@property (nonatomic, strong) void(^exitBlock)();
@property (nonatomic, strong) void(^confirmBlock)();
@property (nonatomic, strong) void(^resetBlock)();
@property (nonatomic, assign) BOOL canReset;//default is YES
@end

//
//  QAPhotoSelectionTitleView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoSelectionTitleView : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isFold;
@property (nonatomic, strong) void(^statusChangedBlock)(void);
@end

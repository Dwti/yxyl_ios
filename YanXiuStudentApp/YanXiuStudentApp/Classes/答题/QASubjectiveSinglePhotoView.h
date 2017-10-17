//
//  QASubjectiveSinglePhotoView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QASubjectiveSinglePhotoView : UIView
@property (nonatomic, strong) void(^clickBlock)(void);
@property (nonatomic, strong) void(^deleteBlock)(void);

@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, strong) QAImageAnswer *imageAnswer;
@property (nonatomic, assign) BOOL showImageBorder;
@end

//
//  CameraView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/11/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Album)(void);
typedef void (^Camera)(void);

@interface CameraView : UIView

@property (nonatomic, copy) Album album;
@property (nonatomic, copy) Camera camera;
- (void)setAlbum:(Album)album;
- (void)setCamera:(Camera)camera;

@end

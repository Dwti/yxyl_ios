//
//  PlayBottomView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideProgressControl.h"

@interface PlayBottomView : UIView
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) SlideProgressControl *slideProgressControl;
@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *definitionButton;
@property (nonatomic, assign) BOOL isShowDefinition;
@property (nonatomic, assign) BOOL isFullscreen;
@end

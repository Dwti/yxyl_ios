//
//  QAPhotoBrowseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoBrowseView : QASlideItemBaseView
@property (nonatomic, strong) QAImageAnswer *imageAnswer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@end

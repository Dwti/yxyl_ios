//
//  QAListenPlayView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAListenPlayView : UIView
@property (nonatomic, strong) QAQuestion *item;


- (void)stop;//退出后台后停止播放
@end

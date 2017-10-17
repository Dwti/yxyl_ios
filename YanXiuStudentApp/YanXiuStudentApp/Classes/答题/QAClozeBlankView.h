//
//  QAClozeBlankView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAClozeBlankView : UIView
@property (nonatomic, strong) void(^clickAction)(void);

- (void)updateWithIndex:(NSInteger)index answer:(NSString *)answer;
- (void)enter;
- (void)enterAnimated:(BOOL)animated;
- (void)leave;

- (void)updateWithState:(YXQAAnswerState)state current:(BOOL)isCurrent;
@end

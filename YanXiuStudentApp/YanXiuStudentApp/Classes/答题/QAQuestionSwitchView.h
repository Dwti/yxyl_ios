//
//  QAQuestionSwitchView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAQuestionSwitchView : UIView
@property (nonatomic, strong) void(^preBlock)();
@property (nonatomic, strong) void(^nextBlock)();
@property (nonatomic, strong) void(^completeBlock)();
@property (nonatomic, assign) BOOL lastButtonHidden;

- (void)updateWithTotal:(NSInteger)total question:(QAQuestion *)question childIndex:(NSInteger)index;
@end

//
//  QAQuestionNumberButton.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickActionBlock)(void);

@interface QAQuestionNumberButton : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;

- (void)setClickActionBlock:(ClickActionBlock)block;
@end

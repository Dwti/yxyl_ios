//
//  QASubmitButton.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SubmitBlock)(void);

@interface QASubmitButton : UIButton

@property (nonatomic, strong) NSString *title;
- (void)setSubmitBlock:(SubmitBlock)block;

@end

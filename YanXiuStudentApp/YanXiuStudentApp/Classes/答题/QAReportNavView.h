//
//  QAReportNavView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BackActionBlock)(void);

@interface QAReportNavView : UIView
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

- (void)setBackActionBlock:(BackActionBlock)block;

@end

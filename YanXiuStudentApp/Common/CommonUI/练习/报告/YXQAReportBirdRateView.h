//
//  YXQAReportBirdRateView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/11.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAReportBirdRateView : UIView
@property (nonatomic, assign) CGFloat rate;

- (instancetype)initWithFrame:(CGRect)frame birdCount:(NSInteger)count;
@end

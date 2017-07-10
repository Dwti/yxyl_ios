//
//  QAClassifyCategoryView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAClassifyCategoryView : UIView
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) NSInteger optionsCount;

@property (nonatomic, strong) void(^clickBlock) ();

+ (CGFloat)widthForCategory:(NSString *)categoryName;
@end

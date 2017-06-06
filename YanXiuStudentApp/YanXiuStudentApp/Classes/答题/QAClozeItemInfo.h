//
//  QAClozeItemInfo.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAClozeItemInfo : NSObject
@property (nonatomic, assign) NSRange blankRange;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIView *coverView;
@end

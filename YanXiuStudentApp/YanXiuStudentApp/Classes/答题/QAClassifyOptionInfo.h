//
//  QAClassifyOptionInfo.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAClassifyOptionInfo : NSObject
@property (nonatomic, strong) NSString *option;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger index;
@end

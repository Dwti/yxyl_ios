//
//  QABlankItemInfo.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QABlankItemInfo : NSObject
@property (nonatomic, assign) NSRange blankRange;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSMutableArray *viewArray;

- (NSString *)displayedString;
@end

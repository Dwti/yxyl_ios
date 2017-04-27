//
//  YXQAConnectStateManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/10.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXQAConnectItemView.h"

@interface YXQAConnectStateManager : NSObject
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) void(^refreshBlock)();
- (void)setup;
@end

//
//  QACoreTextViewHandler.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QACoreTextViewHandler : NSObject

@property (nonatomic, strong) void(^relayoutBlock)();
@property (nonatomic, strong) void(^heightChangeBlock)(CGFloat height);

- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view maxWidth:(CGFloat)width;

@end

//
//  QACoreTextViewHandler.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QACoreTextViewHandlerDelegate <NSObject>
- (UIView *)viewForAttachment:(DTTextAttachment *)attachment;
@end

@interface QACoreTextViewHandler : NSObject

@property (nonatomic, strong) void(^relayoutBlock)(void);
@property (nonatomic, strong) void(^heightChangeBlock)(CGFloat height);

@property (nonatomic, weak) id<QACoreTextViewHandlerDelegate> delegate;

- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view maxWidth:(CGFloat)width;

@end

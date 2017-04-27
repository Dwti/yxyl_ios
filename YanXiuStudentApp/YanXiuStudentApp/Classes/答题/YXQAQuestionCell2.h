//
//  YXQAQuestionCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHtmlCellHeightDelegate.h"

@interface YXQAQuestionCell2 : UITableViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, assign) BOOL dashLineHidden;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, copy) void(^refreshBlock)(DTAttributedTextContentView *htmlView);
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;

+ (CGFloat)heightForString:(NSString *)string dashHidden:(BOOL)dashHidden;
+ (CGFloat)maxContentWidth;

@end

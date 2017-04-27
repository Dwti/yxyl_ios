//
//  YXQAConnectItemView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXQAConnectState) {
    YXQAConnectStateDefault,
    YXQAConnectStateSelected,
    YXQAConnectStateConnected
};

@interface YXQAConnectItemView : UIView
@property (nonatomic, assign) CGFloat maxContentWidth;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

@property (nonatomic, assign) YXQAConnectState state;

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width;
@end

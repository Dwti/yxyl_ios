//
//  YXAppConstants.h
//  YXVideoDemo
//
//  Created by ChenJianjun on 15/5/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 颜色值 */
#define kButtonHighlightDefaultColor [[UIColor colorWithHexString:@"#e2e2e2"] colorWithAlphaComponent:0.4]

#define YXMainBlueColor [YXAppConstants colorWithHexString:@"40c0fc"]     // 主体蓝
#define YXMainDarkBlueColor [YXAppConstants colorWithHexString:@"00a0e6"] // 主体深蓝

#define YXTextBlackColor [YXAppConstants colorWithHexString:@"323232"]     // 文本黑
#define YXTextGrayColor [YXAppConstants colorWithHexString:@"646464"]      // 文本灰
#define YXTextLightGrayColor [YXAppConstants colorWithHexString:@"969696"] // 文本浅灰

#define YXBGGrayColor [YXAppConstants colorWithHexString:@"faf9f9"] // 背景灰
#define YXLineColor [YXAppConstants colorWithHexString:@"e2e2e2"]   // 分割线

// [UIFont fontWithName:size:]
#define YXFontZhengHei      @"FZZZHONGJW--GB1-0"
#define YXFontArial         @"ArialRoundedMTBold"
#define YXFontMetro_Bold        @"Metro-Bold"
#define YXFontMetro_Medium        @"Metro-Medium"

#define YXFontMetro_Regular     @"Metro"
#define YXFontMetro_Light       @"Metro-Light"
#define YXFontMetro_DemiBold       @"Metro-DemiBold"

#define YXFontArialNarrow     @"ArialNarrow"
#define YXFontArialNarrow_Bold       @"ArialNarrow-Bold"

@interface YXAppConstants : NSObject

+ (UIColor *)colorWithHexString:(NSString *)string;

@end

//
//  YXQACoreTextHelper.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/4.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQACoreTextHelper.h"

@implementation YXQACoreTextHelper

#pragma mark - Public
+ (NSAttributedString *)attributedStringForString:(NSString *)string{
    NSData *htmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *option = [YXQACoreTextHelper defaultCoreTextOptions];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:option documentAttributes:nil];
    NSRange entireRange = NSMakeRange(0, [attrString length]);
    [attrString enumerateAttribute:NSAttachmentAttributeName inRange:entireRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.displaySize = CGSizeZero;
            attachment.originalSize = CGSizeZero;
        }
    }];
    return attrString;
}

+ (NSAttributedString *)centerAttributedStringForString:(NSString *)string{
    NSData *htmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *option = [YXQACoreTextHelper defaultCoreTextOptions];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:option];
    [dic setValue:@(kCTTextAlignmentCenter) forKey:DTDefaultTextAlignment];
    return [[NSAttributedString alloc] initWithHTMLData:htmlData options:dic documentAttributes:nil];
}

+ (CGFloat)heightForString:(NSString *)string constraintedToWidth:(CGFloat)width{
    DTAttributedTextContentView *v = [[DTAttributedTextContentView alloc]init];
    NSAttributedString *attrString = [YXQACoreTextHelper attributedStringForString:string];
    v.attributedString = attrString;
    CGSize size = [v suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    return size.height;

}

+ (NSAttributedString *)labelUsedAttributedStringForString:(NSString *)string {
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:1.25], NSTextSizeMultiplierDocumentOption,
                            [UIColor colorWithHexString:@"#323232"], DTDefaultTextColor,
                            [NSNumber numberWithBool:YES], DTUseiOS6Attributes,
                            nil];
    NSData *htmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:option documentAttributes:nil];
    return attrString;
}

#pragma mark - Private
+ (NSDictionary *)defaultCoreTextOptions{
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:1.25], NSTextSizeMultiplierDocumentOption,
                            [UIColor colorWithHexString:@"#323232"], DTDefaultTextColor,
                            [NSNumber numberWithFloat:1.5], DTDefaultLineHeightMultiplier,
                            nil];
    return option;
}

#pragma mark - 3.0 new
+ (NSDictionary *)defaultOptionsForLevel1 {
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            font.familyName, DTDefaultFontFamily,
                            font.fontName, DTDefaultFontName,
                            @(17), DTDefaultFontSize,
                            [UIColor colorWithHexString:@"333333"], DTDefaultTextColor,
                            @(1.5), DTDefaultLineHeightMultiplier,
                            nil];
    return option;
}

+ (NSDictionary *)defaultOptionsForLevel2 {
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            font.familyName, DTDefaultFontFamily,
                            font.fontName, DTDefaultFontName,
                            @(15), DTDefaultFontSize,
                            [UIColor colorWithHexString:@"333333"], DTDefaultTextColor,
                            @(1.5), DTDefaultLineHeightMultiplier,
                            nil];
    return option;
}

+ (NSDictionary *)defaultOptionsForLevel3 {
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            font.familyName, DTDefaultFontFamily,
                            font.fontName, DTDefaultFontName,
                            @(15), DTDefaultFontSize,
                            [UIColor colorWithHexString:@"666666"], DTDefaultTextColor,
                            @(1.5), DTDefaultLineHeightMultiplier,
                            nil];
    return option;
}

+ (NSDictionary *)optionsForClozeStem {
    UIFont *font = [UIFont fontWithName:YXFontArialNarrow size:17];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
                            font.familyName, DTDefaultFontFamily,
                            font.fontName, DTDefaultFontName,
                            @(17), DTDefaultFontSize,
                            [UIColor colorWithHexString:@"333333"], DTDefaultTextColor,
                            @(1.5), DTDefaultLineHeightMultiplier,
                            nil];
    return option;
}

+ (CGFloat)heightForString:(NSString *)string options:(NSDictionary *)option width:(CGFloat)width{
    DTAttributedTextContentView *v = [[DTAttributedTextContentView alloc]init];
    NSAttributedString *attrString = [self attributedStringWithString:string options:option];
    v.attributedString = attrString;
    CGSize size = [v suggestedFrameSizeToFitEntireStringConstraintedToWidth:width];
    return size.height;
}

+ (NSAttributedString *)attributedStringWithString:(NSString *)string options:(NSDictionary *)option {
    NSData *htmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:htmlData options:option documentAttributes:nil];
    [self clearImageSizeInAttributedString:attrString];
    return attrString;
}

+ (void)clearImageSizeInAttributedString:(NSAttributedString *)attrString {
    NSRange entireRange = NSMakeRange(0, [attrString length]);
    [attrString enumerateAttribute:NSAttachmentAttributeName inRange:entireRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
        if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
            attachment.displaySize = CGSizeZero;
            attachment.originalSize = CGSizeZero;
        }
    }];
}

@end

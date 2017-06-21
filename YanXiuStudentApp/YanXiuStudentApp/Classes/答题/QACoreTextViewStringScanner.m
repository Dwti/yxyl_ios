//
//  QACoreTextViewStringScanner.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QACoreTextViewStringScanner.h"

@interface QACoreTextViewStringScanner ()
@property (nonatomic, strong) NSMutableArray *imagePositionArray;
@property (nonatomic, strong) NSArray *indexArray;
@end

@implementation QACoreTextViewStringScanner

- (void)scanCoreTextView:(DTAttributedTextContentView *)view string:(NSString *)string scanBlock:(ScanResultBlock)scanBlock {
    if (!self.imagePositionArray) {
        self.imagePositionArray = [NSMutableArray array];
        NSRange entireRange = NSMakeRange(0, [view.attributedString length]);
        [view.attributedString enumerateAttribute:NSAttachmentAttributeName inRange:entireRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
            if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
                [self.imagePositionArray addObject:[NSNumber numberWithUnsignedInteger:range.location]];
            }
        }];
    }
    
    if (!self.indexArray) {
        self.indexArray = [NSArray arrayWithArray:[view.layoutFrame stringIndices]];
    }
    
    NSString *pattern2 = string;
    NSRegularExpression *reg2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:nil];
    NSArray *match = [reg2 matchesInString:view.attributedString.plainTextString options:NSMatchingReportCompletion range:NSMakeRange(0, [view.attributedString.plainTextString length])];
    
    [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull matc, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect aFrame;
        CGRect bFrame;
        NSInteger aPos = [self glyphIndexForStringIndex:matc.range.location];
        NSInteger bPos = [self glyphIndexForStringIndex:(matc.range.location + matc.range.length-1)];
        aFrame = [view.layoutFrame frameOfGlyphAtIndex:aPos];
        bFrame = [view.layoutFrame frameOfGlyphAtIndex:bPos];
        
        CGRect frame = [self rectValueFromRect:aFrame toRect:bFrame].CGRectValue;
        BLOCK_EXEC(scanBlock,idx,match.count,frame);
    }];
}

- (void)scanCoreTextView:(DTAttributedTextContentView *)view stringRange:(NSRange)range resultBlock:(void(^)(NSArray *frameArray))resultBlock {
    if (!self.imagePositionArray) {
        self.imagePositionArray = [NSMutableArray array];
        NSRange entireRange = NSMakeRange(0, [view.attributedString length]);
        [view.attributedString enumerateAttribute:NSAttachmentAttributeName inRange:entireRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *attachment, NSRange range, BOOL *stop) {
            if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
                [self.imagePositionArray addObject:[NSNumber numberWithUnsignedInteger:range.location]];
            }
        }];
    }
    
    self.indexArray = [NSArray arrayWithArray:[view.layoutFrame stringIndices]];
    
    NSInteger start = [self glyphIndexForStringIndex:range.location];
    NSInteger end = [self glyphIndexForStringIndex:range.location+range.length-1];
    CGRect startFrame = [view.layoutFrame frameOfGlyphAtIndex:start];
    CGRect endFrame = [view.layoutFrame frameOfGlyphAtIndex:end];
    if ([self isSameLineForStartFrame:startFrame endFrame:endFrame]) {
        NSValue *value = [self rectValueFromRect:startFrame toRect:endFrame];
        BLOCK_EXEC(resultBlock,@[value]);
    }else {
        NSMutableArray *mArray = [NSMutableArray array];
        NSInteger temp = end;
        while (temp > start) {
            temp--;
            CGRect frame = [view.layoutFrame frameOfGlyphAtIndex:temp];
            if ([self isSameLineForStartFrame:frame endFrame:endFrame]) {
                continue;
            }else {
                NSInteger index = temp+1;
                CGRect lineStartFrame = [view.layoutFrame frameOfGlyphAtIndex:index];
                [mArray insertObject:[self rectValueFromRect:lineStartFrame toRect:endFrame] atIndex:0];
                endFrame = frame;
            }
            
            if ([self isSameLineForStartFrame:startFrame endFrame:frame]) {
                [mArray insertObject:[self rectValueFromRect:startFrame toRect:frame] atIndex:0];
                break;
            }
        }
        BLOCK_EXEC(resultBlock,mArray);
    }
}

- (NSInteger)glyphIndexForStringIndex:(NSInteger)index {
    NSInteger adjustIndex = index;
    for (NSNumber *i in self.imagePositionArray) {
        if ([i integerValue] <= adjustIndex) {
            adjustIndex++;
        }
    }
    NSInteger glyphIndex = 0;
    for (NSNumber *i in self.indexArray) {
        if ([i integerValue] <= adjustIndex) {
            glyphIndex++;
        } else {
            break;
        }
    }
    glyphIndex--;
    return glyphIndex;
}

- (BOOL)isSameLineForStartFrame:(CGRect)start endFrame:(CGRect)end {
    if (ABS(start.origin.y-end.origin.y)<10) {
        return YES;
    }
    return NO;
}

- (NSValue *)rectValueFromRect:(CGRect)from toRect:(CGRect)to {
    return [NSValue valueWithCGRect:CGRectMake(floorf(from.origin.x), floorf(from.origin.y), ceilf(to.origin.x-from.origin.x+to.size.width), ceilf(from.size.height))];
}

@end

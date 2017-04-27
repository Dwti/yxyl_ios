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
        
        CGRect frame = CGRectMake(aFrame.origin.x, aFrame.origin.y, bFrame.origin.x - aFrame.origin.x + bFrame.size.width, aFrame.size.height);
        BLOCK_EXEC(scanBlock,idx,match.count,frame);
    }];
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

@end

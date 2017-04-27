//
//  QACoreTextViewStringScanner.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ScanResultBlock)(NSInteger index, NSInteger total, CGRect frame);

@interface QACoreTextViewStringScanner : NSObject
- (void)scanCoreTextView:(DTAttributedTextContentView *)view string:(NSString *)string scanBlock:(ScanResultBlock)scanBlock;
@end

//
//  QAReadStemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAComplexHeaderCellDelegate.h"

@interface QAReadStemCell : UITableViewCell<QAComplexHeaderCellDelegate>
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub;
+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub;
@end

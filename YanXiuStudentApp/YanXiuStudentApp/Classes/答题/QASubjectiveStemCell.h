//
//  QASubjectiveStemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QASubjectiveStemCell : UITableViewCell
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub;
+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub;
@end

//
//  QAChooseOptionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAChooseOptionCell : UITableViewCell
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL choosed;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
- (void)updateWithOption:(NSString *)option forIndex:(NSInteger)index;
@end

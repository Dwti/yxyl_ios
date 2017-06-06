//
//  QAClozeStemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAClozeQuestionCellDelegate.h"

@interface QAClozeStemCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) id<QAClozeQuestionCellDelegate> selectItemDelegate;

+ (CGFloat)heightForString:(NSString *)string;

- (UIView *)currentBlankView;
- (void)refresh;
@end

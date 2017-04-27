//
//  YXClassesQuestionCell.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/8/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHtmlCellHeightDelegate.h"

@interface YXClassesQuestionCell : UITableViewCell

@property (nonatomic, copy) NSString *question;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
- (CGFloat)cellHeight;

@end

//
//  QAClassifyAnswerResultCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAClassifyAnswerResultCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *question;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForQuestion:(QAQuestion *)question;
@end

//
//  QAQuestionStemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAQuestionStemCell : UITableViewCell
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, assign) BOOL bottomLineHidden;

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub;
+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub;
@end

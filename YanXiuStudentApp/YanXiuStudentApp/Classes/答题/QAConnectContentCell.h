//
//  QAConnectContentCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAConnectContentCell : UITableViewCell
@property (nonatomic, assign) CGFloat maxContentWidth;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width;

@end

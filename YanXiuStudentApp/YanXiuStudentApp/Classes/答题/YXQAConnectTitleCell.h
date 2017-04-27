//
//  YXQAConnectTitleCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAConnectTitleCell : UITableViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
@end

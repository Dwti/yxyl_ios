//
//  YXLabelHtmlCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface YXLabelHtmlCell2 : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxImageWidth:(CGFloat)width;

@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, assign) CGFloat maxImageWidth;

+ (CGFloat)heightForString:(NSString *)string;
@end

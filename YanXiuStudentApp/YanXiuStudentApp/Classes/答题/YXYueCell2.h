//
//  YXYueCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/15.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHtmlCellHeightDelegate.h"

@interface YXYueCell2 : UITableViewCell
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;

+ (CGFloat)heightForString:(NSString *)string;
@end

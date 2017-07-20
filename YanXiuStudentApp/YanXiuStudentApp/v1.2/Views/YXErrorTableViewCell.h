//
//  YXErrorTableViewCell.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHtmlCellHeightDelegate.h"

@protocol YXErrorTableViewCellDelegate <NSObject>

- (void)deleteItem:(QAQuestion *)item;

@end

@interface YXErrorTableViewCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate, YXErrorTableViewCellDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;

@end

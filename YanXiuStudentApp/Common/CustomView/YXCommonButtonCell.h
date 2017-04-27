//
//  YXCommonButtonCell.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/18.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCommonButtonCellIdentifier;

/**
 *  退出等通用按钮Cell
 */
@interface YXCommonButtonCell : UITableViewCell

- (void)setButtonText:(NSString *)text;

@end

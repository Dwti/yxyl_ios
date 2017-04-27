//
//  YXHtmlCellHeightDelegate.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/14/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXHtmlCellHeightDelegate <NSObject>
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height;
@end

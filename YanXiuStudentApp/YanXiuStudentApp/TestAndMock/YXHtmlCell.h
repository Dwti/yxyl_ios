//
//  YXHtmlCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/13/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXHtmlCell;

@protocol YXHtmlCellDelegate <NSObject>
- (void)htmlCell:(YXHtmlCell *)cell updateWithHeight:(CGFloat)height;
@end

@interface YXHtmlCell : UITableViewCell
@property (nonatomic, assign) int index;
@property (nonatomic, weak) id<YXHtmlCellDelegate> delegate;
- (void)updateWithData:(NSString *)path;
@end

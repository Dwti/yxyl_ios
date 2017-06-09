//
//  QAListenStemCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAComplexHeaderCellDelegate.h"
#import "QAListenPlayView.h"

@interface QAListenStemCell : UITableViewCell<QAComplexHeaderCellDelegate>
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QAListenPlayView *playView;
- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub;
+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub;

- (void)stop;//退出后台后停止播放
@end

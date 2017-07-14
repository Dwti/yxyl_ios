//
//  QAConnectContentCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeightChangeBlock)(CGFloat height);

@interface QAConnectContentCell : UITableViewCell
@property (nonatomic, strong) NSString *optionString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)setHeightChangeBlock:(HeightChangeBlock)block;

- (CGSize)defaultSize;
@end

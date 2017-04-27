//
//  YXMineTableViewCell.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kYXMineCellIdentifier;

@interface YXMineTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isTextLabelInset; //文本紧靠图片
@property (nonatomic, assign) BOOL showLine; //显示虚线
@property (nonatomic, assign) BOOL accessoryViewHidden; //隐藏accessoryView

- (void)setTitle:(NSString *)title image:(UIImage *)image;
- (void)setTitle:(NSString *)title account:(NSString *)account;

// 更新附文本
- (void)updateWithAccessoryText:(NSString *)accessoryText;
- (void)updateWithAccessoryCustomText:(NSString *)customText;
- (void)updateWithAccessoryText:(NSString *)accessoryText isBoldFont:(BOOL)isBoldFont;

// 更新网络图
- (void)updateWithImageUrl:(NSString *)url
              defaultImage:(UIImage *)defaultImage;

@end

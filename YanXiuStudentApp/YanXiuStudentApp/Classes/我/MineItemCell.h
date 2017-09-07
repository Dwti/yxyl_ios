//
//  MineItemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineItemCell : UITableViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) BOOL shouldShowShadow;
@property (nonatomic, assign) BOOL shouldShowIcon;

@end

//
//  TreeBaseCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeBaseCell : UITableViewCell
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isExpand;

- (void)setupUI;
@end

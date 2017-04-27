//
//  YXSideMenuNormalCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXSideMenuNormalCellType) {
    YXSideMenuRank,
//    YXSideMenuFavor,
    YXSideMenuMistake,
    YXSideMenuHistory,
    YXSideMenuSetting
};

@interface YXSideMenuNormalCell_Pad : UITableViewCell

@property (nonatomic, assign) YXSideMenuNormalCellType type;
@property (nonatomic, assign) BOOL dashLineHidden;

@end

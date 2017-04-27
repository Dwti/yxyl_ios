//
//  YXDashLineCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/2/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDashLineCell : UITableViewCell
@property (nonatomic, assign) int realWidth;
@property (nonatomic, assign) int dashWidth;
@property (nonatomic, assign) BOOL bHasShadow;
@property (nonatomic, strong) UIColor *realColor;
@property (nonatomic, strong) UIColor *shadowColor;

@property (nonatomic, assign) int preferedGapToCellBounds;
@end

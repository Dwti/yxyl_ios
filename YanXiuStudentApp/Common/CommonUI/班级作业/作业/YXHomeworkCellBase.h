//
//  YXHomeworkCellBase.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXHomeworkCellBase : UITableViewCell
@property (nonatomic, copy) void (^clickBlock)();

@property (nonatomic, strong) UIView *bottomLeftContainerView;
@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, assign) CGFloat edgeInterval;
@property (nonatomic, assign) CGFloat clockInterval;

@end

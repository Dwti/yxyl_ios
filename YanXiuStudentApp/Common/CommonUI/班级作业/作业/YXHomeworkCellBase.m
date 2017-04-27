//
//  YXHomeworkCellBase.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCellBase.h"
#import "YXDashLineCell.h"

@interface YXHomeworkCellBase ()
@property (nonatomic, strong) UIButton *clickEffectButton;

@property (nonatomic, strong) UIView *topContainerView;

@property (nonatomic, strong) UIImageView *accessoryImageView;
@property (nonatomic, strong) UIImageView *clockImageView;
@end

@implementation YXHomeworkCellBase

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.clickEffectButton;
    }
    return nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.edgeInterval = 35.f;
        self.clockInterval = 100.f;
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.clickEffectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *clickEffectImage = [[UIImage imageNamed:@"列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)];
    UIImage *clickEffectImageH = [[UIImage imageNamed:@"列表背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 30, 24, 30)];
    [self.clickEffectButton setBackgroundImage:clickEffectImage forState:UIControlStateNormal];
    [self.clickEffectButton setBackgroundImage:clickEffectImageH forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.clickEffectButton];
    [self.clickEffectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-0.5f, self.edgeInterval, -0.5f, self.edgeInterval));
    }];

    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor clearColor];
    [self.clickEffectButton addSubview:self.topContainerView];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    YXDashLineCell *cell = [[YXDashLineCell alloc] init];
    cell.realWidth = 4;
    cell.dashWidth = 3;
    cell.preferedGapToCellBounds = 3;
    cell.bHasShadow = YES;
    cell.realColor = [UIColor colorWithHexString:@"e4b62e"];
    cell.shadowColor = [UIColor colorWithHexString:@"ffeb66"];
    [self.clickEffectButton addSubview:cell];
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(48);
        make.left.mas_equalTo(4.f);
        make.right.mas_equalTo(-4.f);
        make.height.mas_equalTo(2);
    }];
    
    self.bottomContainerView = [[UIView alloc] init];
    self.bottomContainerView.backgroundColor = [UIColor clearColor];
    [self.clickEffectButton addSubview:self.bottomContainerView];
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.bottom.left.right.mas_equalTo(0);
    }];

    // top container
    self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色右箭头"]];
    [self.topContainerView addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(2.f);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont systemFontOfSize:17];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.numberLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.numberLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.numberLabel.layer.shadowOpacity = 1;
    self.numberLabel.layer.shadowRadius = 0;
    [self.topContainerView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.accessoryImageView.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.accessoryImageView.mas_centerY);
    }];
    [self.numberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.numberLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.nameLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowRadius = 0;
    [self.topContainerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.f + 15);
        make.centerY.mas_equalTo(self.accessoryImageView.mas_centerY);
        make.right.mas_lessThanOrEqualTo(self.numberLabel.mas_left).mas_offset(-10);
    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // bottom container
    self.clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"时间"]];
    [self.bottomContainerView addSubview:self.clockImageView];
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clockInterval);
        make.centerY.mas_equalTo(-2.f);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.timeLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.timeLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.timeLabel.layer.shadowOpacity = 1;
    self.timeLabel.layer.shadowRadius = 0;
    [self.bottomContainerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clockImageView.mas_right).mas_offset(4);
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(self.clockImageView.mas_centerY);
    }];
    
    self.bottomLeftContainerView = [[UIView alloc] init];
    self.bottomLeftContainerView.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:self.bottomLeftContainerView];
    [self.bottomLeftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(self.clockImageView.mas_left);
    }];
    
    [self.clickEffectButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEdgeInterval:(CGFloat)edgeInterval
{
    _edgeInterval = edgeInterval;
    if (self.clickEffectButton) {
        [self.clickEffectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(-0.5f, edgeInterval, -0.5f, edgeInterval));
        }];
    }
}

- (void)setClockInterval:(CGFloat)clockInterval
{
    _clockInterval = clockInterval;
    if (self.clockImageView) {
        [self.clockImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(clockInterval);
            make.centerY.mas_equalTo(-2.f);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
}

- (void)clickAction:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end

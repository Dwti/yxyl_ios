//
//  YXHomeworkCell2.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCell2_2.h"
#import "YXDashLineCell.h"

@interface YXHomeworkCell2_2()

@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *commentImageView;

@property (nonatomic, strong) UIButton *clickEffectButton;

@property (nonatomic, strong) UIView *topContainerView;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) UIView *bottomLeftContainerView;
@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, assign) CGFloat edgeInterval;
@property (nonatomic, assign) CGFloat clockInterval;


@end

@implementation YXHomeworkCell2_2

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
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.nameLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowRadius = 0;
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.topContainerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.accessoryImageView.mas_left).offset = -10;
        make.left.mas_equalTo(2.f + 15);
        make.centerY.mas_equalTo(self.accessoryImageView.mas_centerY);
    }];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.timeLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.timeLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.timeLabel.layer.shadowOpacity = 1;
    self.timeLabel.layer.shadowRadius = 0;
    [self.bottomContainerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15.f);
        make.left.offset = 15;
        make.centerY.mas_equalTo(-2.f);
    }];
    
    self.bottomLeftContainerView = [[UIView alloc] init];
    self.bottomLeftContainerView.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:self.bottomLeftContainerView];
    [self.bottomLeftContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
    _commentImageView = [UIImageView new];
    _commentImageView.image = [UIImage imageNamed:@"老师评语背景"];
    
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

- (void)clickAction:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)updateWithData:(YXHomeworkMock *)data {
    for (UIView *v in self.bottomLeftContainerView.subviews) {
        [v removeFromSuperview];
    }
    
    self.nameLabel.text = data.name;
    data.rawData.remaindertimeStr = data.rawData.remaindertimeStr.length? data.rawData.remaindertimeStr: @"0";
    if ([data.rawData.remaindertimeStr isEqualToString:@"0"]) {
        self.timeLabel.text = @"可补做";
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"剩余时间：%@", data.rawData.remaindertimeStr];
    }
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.bottomLeftContainerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    label.layer.shadowRadius = 0;
    [self.bottomLeftContainerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.priority(MASLayoutPriorityFittingSizeLevel);
        make.left.greaterThanOrEqualTo(label.mas_right).offset = 10;
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(-2.f);
    }];
    
    iconImageView.image = [UIImage imageNamed:data.stateString];
    label.text = data.stateString;
    NSString *state = data.stateString;
    self.timeLabel.hidden = ![state isEqualToString:YXHomeWorkStatusPartFinish];
    self.status = state;
    if ([state isEqualToString:YXHomeWorkStatusNeverFinish]) {
        label.textColor = [UIColor colorWithHexString:@"007373"];
    }
    if ([state isEqualToString:YXHomeWorkStatusPartFinish]) {
        label.textColor = [UIColor colorWithHexString:@"b3476b"];
        NSString *answernum = data.rawData.answernum;
        answernum = answernum.integerValue? answernum: @"0";
        self.answerNum = answernum;
        label.text = [label.text  stringByAppendingFormat:@"%@/%@ ", answernum, data.rawData.quesnum];
    }
    if ([state isEqualToString:YXHomeWorkStatusAllFinish]) {
        label.textColor = [UIColor colorWithHexString:@"805500"];
    }
    
    if ([data.rawData hasTeacherComments]) {
        [self.bottomContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.height.mas_equalTo(42);
            make.left.right.mas_equalTo(0);
        }];
        
        self.commentLabel.text = [NSString stringWithFormat:@"%@：%@", data.teacher, data.comment];
        [self.bottomContainerView.superview addSubview:self.commentImageView];
        [self.bottomContainerView.superview addSubview:self.commentLabel];
        [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.right.offset = -15;
            make.top.mas_equalTo(self.topContainerView.mas_bottom).offset(15);
            make.height.mas_equalTo(self.commentLabel.mas_height).offset = 30;
        }];
        [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.commentImageView.mas_top).offset(15);
            make.right.mas_equalTo(-30);
            make.left.mas_equalTo(30);
        }];
        [self.bottomContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.commentImageView.mas_height).mas_offset(20).priorityHigh();
            make.bottom.offset = -15;
        }];
    } else {
        [self.commentLabel removeFromSuperview];
        [self.commentImageView removeFromSuperview];
        [self.bottomContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.bottom.left.right.mas_equalTo(0);
        }];
    }
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.textColor = [UIColor colorWithHexString:@"805500"];
        _commentLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
        _commentLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _commentLabel.layer.shadowOpacity = 1;
        _commentLabel.layer.shadowRadius = 0;
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

@end

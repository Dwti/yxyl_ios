//
//  YXHomeworkSubjectCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkSubjectCell.h"
#import "YXDashLineCell.h"

@interface YXHomeworkSubjectCell ()
@property (nonatomic, strong) UIButton *clickEffectButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) YXDashLineCell *dashCell;
@property (nonatomic, strong) UILabel *newestLabel;
@end

@implementation YXHomeworkSubjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.interval = 35.f;
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(-0.5f, self.interval, -0.5f, self.interval));
    }];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.clickEffectButton addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.nameLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.nameLabel.layer.shadowOpacity = 1;
    self.nameLabel.layer.shadowRadius = 0;
    [self.clickEffectButton addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY).mas_offset(2);
    }];
//    self.iconImageView.backgroundColor = [UIColor redColor];
//    self.nameLabel.backgroundColor = [UIColor redColor];
    
    self.accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蓝色右箭头"]];
    [self.clickEffectButton addSubview:self.accessoryImageView];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
    
    [self.clickEffectButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInterval:(CGFloat)interval
{
    _interval = interval;
    if (self.clickEffectButton) {
        [self.clickEffectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(-0.5f, interval, -0.5f, interval));
        }];
    }
}

- (void)_setupUI2 {
//    [self.dashCell removeFromSuperview];
//    [self.newestLabel removeFromSuperview];
//    
//    YXDashLineCell *cell = [[YXDashLineCell alloc] init];
//    cell.realWidth = 4;
//    cell.dashWidth = 3;
//    cell.preferedGapToCellBounds = 3;
//    cell.bHasShadow = YES;
//    cell.realColor = [UIColor colorWithHexString:@"e4b62e"];
//    cell.shadowColor = [UIColor colorWithHexString:@"ffeb66"];
//    [self.clickEffectButton addSubview:cell];
//    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(48);
//        make.left.mas_equalTo(4.5);
//        make.right.mas_equalTo(-4.5);
//        make.height.mas_equalTo(2);
//    }];
//    self.dashCell = cell;
    
    self.newestLabel = [[UILabel alloc] init];
    self.newestLabel.backgroundColor = [UIColor clearColor];
//    self.newestLabel.textColor = [UIColor colorWithHexString:@"ffdb4d"];
    self.newestLabel.font = [UIFont boldSystemFontOfSize:13];
    self.newestLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.newestLabel.text = @"最新作业";
//    self.newestLabel.textAlignment = NSTextAlignmentCenter;
//    self.newestLabel.layer.cornerRadius = 4;
//    self.newestLabel.clipsToBounds = YES;
    [self.clickEffectButton addSubview:self.newestLabel];
    [self.newestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.nameLabel.mas_right).offset = 10;
        make.right.mas_equalTo(self.accessoryImageView.mas_left).offset = -10;
        make.centerY.mas_equalTo(self.accessoryImageView);
//        make.size.mas_equalTo(CGSizeMake(50, 18));
    }];
    
}

- (void)updateWithData:(YXHomeworkGroupMock *)data {
    [self.dashCell removeFromSuperview];
    [self.newestLabel removeFromSuperview];
    
    NSString *iconName = data.imageName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    
    self.nameLabel.text = data.name;
    [self.nameLabel sizeToFit];
//    if (data.rawData.paper.name.length > 0) {
//        // 有最新作业
        [self _setupUI2];
//    }
    if (data.rawData.waitFinishNum.integerValue) {
        self.newestLabel.text = [NSString stringWithFormat:@"%@份待完成", data.rawData.waitFinishNum];
        self.newestLabel.textColor = [UIColor colorWithRGBHex:0xb3476b];
    }else{
        self.newestLabel.text = @"查看已完成";
        self.newestLabel.textColor = [UIColor colorWithRGBHex:0x805500];
    }
}

- (void)clickAction {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end

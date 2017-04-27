//
//  YXQAReportTitleCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAReportTitleCell.h"

@interface YXQAReportTitleCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *stampImageView;
@end

@implementation YXQAReportTitleCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:containerView];
    
    YXSmartDashLineView *dashView = [[YXSmartDashLineView alloc]init];
    dashView.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    dashView.dashWidth = 4;
    dashView.gapWidth = 3;
    [containerView addSubview:dashView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"118989"];
    [containerView addSubview:self.titleLabel];
    
    self.durationLabel = [[UILabel alloc]init];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.font = [UIFont boldSystemFontOfSize:10];
    self.durationLabel.textColor = [UIColor colorWithHexString:@"99937a"];
    [containerView addSubview:self.durationLabel];
    
    UIImageView *toothView = [[UIImageView alloc]init];
    toothView.image = [UIImage imageNamed:@"白牙齿"];
    [self.contentView addSubview:toothView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(83);
    }];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(1);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(42);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
    }];
    [toothView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(containerView.mas_bottom);
        make.height.mas_equalTo(17);
    }];
    
    self.stampImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.stampImageView];
    [self.stampImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    NSString *time = nil;
    int hour = duration/60/60;
    int min = (duration-hour*60*60)/60;
    int sec = duration-hour*60*60-min*60;
    time = [NSString stringWithFormat:@"本次用时 %02d:%02d:%02d",hour,min,sec];
    self.durationLabel.text = time;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.stampImageView.image = image;
}
@end

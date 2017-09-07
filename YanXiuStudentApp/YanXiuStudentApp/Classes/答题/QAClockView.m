//
//  QAClockView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClockView.h"

@interface QAClockGroupView : UIView
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@end
@implementation QAClockGroupView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *v1 = [[UIView alloc]init];
    v1.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    v1.layer.cornerRadius = 3;
    v1.clipsToBounds = YES;
    [self addSubview:v1];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(15);
    }];
    self.firstLabel = [[UILabel alloc]init];
    self.firstLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:21];
    self.firstLabel.textColor = [UIColor whiteColor];
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    [v1 addSubview:self.firstLabel];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 3/[UIScreen mainScreen].scale));
    }];
    UIView *v2 = [v1 clone];
    [self addSubview:v2];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(v1.mas_right).mas_offset(2);
    }];
    self.secondLabel = [self.firstLabel clone];
    [v2 addSubview:self.secondLabel];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 3/[UIScreen mainScreen].scale));
    }];
}
@end

@interface QAClockView()
@property (nonatomic, strong) QAClockGroupView *hourGroupView;
@property (nonatomic, strong) QAClockGroupView *minuteGroupView;
@property (nonatomic, strong) QAClockGroupView *secondGroupView;
@property (nonatomic, strong) UILabel *firstColonLabel;
@property (nonatomic, strong) UILabel *secondColonLabel;
@end

@implementation QAClockView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.hourGroupView = [[QAClockGroupView alloc]init];
    self.minuteGroupView = [[QAClockGroupView alloc]init];
    self.secondGroupView = [[QAClockGroupView alloc]init];
    
    self.firstColonLabel = [[UILabel alloc]init];
    self.firstColonLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:18];
    self.firstColonLabel.textAlignment = NSTextAlignmentCenter;
    self.firstColonLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    self.firstColonLabel.text = @":";
    
    self.secondColonLabel = [self.firstColonLabel clone];
}

- (void)setSecondsPassed:(NSInteger)secondsPassed {
    _secondsPassed = secondsPassed;
    NSInteger hour = secondsPassed/60/60;
    NSInteger minute = secondsPassed/60 - hour*60;
    NSInteger second = secondsPassed%60;
    self.hourGroupView.firstLabel.text = [NSString stringWithFormat:@"%@",@(hour/10)];
    self.hourGroupView.secondLabel.text = [NSString stringWithFormat:@"%@",@(hour%10)];
    self.minuteGroupView.firstLabel.text = [NSString stringWithFormat:@"%@",@(minute/10)];
    self.minuteGroupView.secondLabel.text = [NSString stringWithFormat:@"%@",@(minute%10)];
    self.secondGroupView.firstLabel.text = [NSString stringWithFormat:@"%@",@(second/10)];
    self.secondGroupView.secondLabel.text = [NSString stringWithFormat:@"%@",@(second%10)];
    
    if (hour == 0) {
        if (self.minuteGroupView.superview) {
            return;
        }
        [self addSubview:self.minuteGroupView];
        [self addSubview:self.secondGroupView];
        [self addSubview:self.secondColonLabel];
        [self.secondColonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(10, 20));
        }];
        [self.minuteGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.secondColonLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(32, 20));
        }];
        [self.secondGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.secondColonLabel.mas_right);
            make.size.mas_equalTo(CGSizeMake(32, 20));
        }];
    }else {
        if (self.hourGroupView.superview) {
            return;
        }
        [self addSubview:self.hourGroupView];
        [self addSubview:self.minuteGroupView];
        [self addSubview:self.secondGroupView];
        [self addSubview:self.firstColonLabel];
        [self addSubview:self.secondColonLabel];
        [self.minuteGroupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(32, 20));
        }];
        [self.secondColonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(10, 20));
            make.left.mas_equalTo(self.minuteGroupView.mas_right);
        }];
        [self.secondGroupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(32, 20));
            make.left.mas_equalTo(self.secondColonLabel.mas_right);
        }];
        [self.firstColonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(10, 20));
            make.right.mas_equalTo(self.minuteGroupView.mas_left);
        }];
        [self.hourGroupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(32, 20));
            make.right.mas_equalTo(self.firstColonLabel.mas_left);
        }];
    }
}

@end

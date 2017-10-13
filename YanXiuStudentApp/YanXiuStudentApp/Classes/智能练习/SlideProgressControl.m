//
//  SlideProgressControl.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SlideProgressControl.h"
#import "SlideProgressView.h"
#import "YXGradientView.h"

@interface SlideProgressControl ()
@property (nonatomic, strong) UIImageView *thumbNormalView;
@property (nonatomic, strong) SlideProgressView *slideProgressView;
@end
@implementation SlideProgressControl
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.bSliding = NO;
    
    self.slideProgressView = [[SlideProgressView alloc] init];
    self.slideProgressView.userInteractionEnabled = NO;
    [self addSubview:self.slideProgressView];
    
    self.thumbNormalView = [[UIImageView alloc] init];
    self.thumbNormalView.frame = CGRectMake(0, 0, 16.0f, 16.0f);
    self.thumbNormalView.backgroundColor = [UIColor whiteColor];
    self.thumbNormalView.layer.cornerRadius = 8.0f;
    self.thumbNormalView.clipsToBounds = YES;
    self.thumbNormalView.layer.masksToBounds = YES;
    [self addSubview:self.thumbNormalView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.timeLabel];
    
    [self.slideProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thumbNormalView.bounds.size.width * 0.5).priorityHigh();
        make.centerY.mas_equalTo(@0);
        make.height.mas_equalTo(@3.0f);
        make.right.equalTo(self.timeLabel.mas_left).offset(-6.0f).priorityHigh();
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.right.mas_equalTo(@-15).priorityHigh();
        make.width.mas_offset(70.0f);
    }];
}

- (void)layoutSubviews {
    [self updateUI];
    [super layoutSubviews];
}

- (void)updateUI {
    self.slideProgressView.playProgress = self.playProgress;
    self.slideProgressView.bufferProgress = self.bufferProgress;
    [self.thumbNormalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0f, 16.0f));
        make.centerX.mas_equalTo(self.slideProgressView.wholeProgressView.mas_left).mas_offset(self.slideProgressView.wholeProgressView.bounds.size.width * self.playProgress);
        make.centerY.mas_equalTo(self.slideProgressView.wholeProgressView.mas_centerY);
    }];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self timeString:self.duration * self.playProgress],[self timeString:self.duration]];
}

- (NSMutableAttributedString *)palyTime:(NSString *)playTime withContent:(NSString *)durationTime{
    NSString *temString = [NSString stringWithFormat:@"%@/%@",playTime,durationTime];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"919191"]} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f],NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, playTime.length + 1)];
    return attributedString;
}

- (NSString *)timeString:(NSTimeInterval)time {
    int minute = (int)(time / 60);
    int second = ((int)time) % 60;
    NSString *ret = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    return ret;
}


#pragma mark - touch event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint([self slidePointImageRect], touchPoint)) {
        self.bSliding = YES;
        self.thumbNormalView.image = [UIImage imageWithColor:[UIColor whiteColor]];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat startX = self.slideProgressView.wholeProgressView.bounds.origin.x;
    CGFloat endX = self.slideProgressView.wholeProgressView.bounds.origin.x + self.slideProgressView.wholeProgressView.bounds.size.width;
    touchPoint.x = MAX(startX, touchPoint.x);
    touchPoint.x = MIN(endX, touchPoint.x);
    
    self.playProgress = (touchPoint.x - startX) / (endX - startX);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsLayout];
    self.bSliding = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.bSliding = NO;
    self.thumbNormalView.image = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (CGRect)slidePointImageRect {
    CGRect rect = self.thumbNormalView.frame;
    rect.size.width  = rect.size.width + 8;//拖动按钮的区域增加8个像素
    rect.size.height = rect.size.height + 8;
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    return rect;
}


@end

//
//  YXChapterPointSegmentControl.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXChapterPointSegmentControl.h"
#import "YXUserManager.h"

@interface YXChapterPointSegmentControl ()
@property (nonatomic, strong) UIView *slideView;
@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@end


@implementation YXChapterPointSegmentControl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.frame = CGRectMake(0, 0, 134, 35);
    self.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    self.layer.cornerRadius = 6;
    self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.layer.borderWidth = 2;
    self.clipsToBounds = YES;
    
    self.slideView = [[UIView alloc] init];
    self.slideView.backgroundColor = [UIColor whiteColor];
    self.slideView.layer.cornerRadius = 4;
    self.slideView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.slideView.layer.borderWidth = 2;
    [self addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(63, 31));
    }];
    
    self.chapterLabel = [[UILabel alloc] init];
    self.chapterLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    self.chapterLabel.text = @"章节";
    self.chapterLabel.textAlignment = NSTextAlignmentLeft;
    self.chapterLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.pointLabel = [[UILabel alloc] init];
    self.pointLabel.textColor = [UIColor whiteColor];
    self.pointLabel.text = @"知识点";
    self.pointLabel.textAlignment = NSTextAlignmentRight;
    self.pointLabel.font = [UIFont boldSystemFontOfSize:14];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.chapterLabel];
    [self addSubview:self.pointLabel];
    
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-33.5);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(33.5);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    //8.2PM修改 除了数理化生,其他科目都不显示知识点
    if (![self.name isEqualToString:@"数学"] && ![self.name isEqualToString:@"物理"] && ![self.name isEqualToString:@"化学"] && ![self.name isEqualToString:@"生物"]) {
        self.hidden = YES;
    }
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if (point.x < self.frame.size.width * 0.5) {
        self.curSelectedIndex = 0;
    } else {
        self.curSelectedIndex = 1;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setCurSelectedIndex:(int)curSelectedIndex {
    if (curSelectedIndex <= 0) {
        _curSelectedIndex = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.chapterLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
            self.pointLabel.textColor = [UIColor whiteColor];
            
            [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(2);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(63, 31));
            }];
            [self layoutIfNeeded];
        }];
    }
    
    if (curSelectedIndex >= 1) {
        _curSelectedIndex = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.chapterLabel.textColor = [UIColor whiteColor];
            self.pointLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
            
            [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-2);
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(63, 31));
            }];
            [self layoutIfNeeded];
        }];
    }
}

@end

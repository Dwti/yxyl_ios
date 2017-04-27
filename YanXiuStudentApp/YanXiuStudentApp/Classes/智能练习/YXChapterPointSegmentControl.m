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
@property (nonatomic, strong) UIImageView *slideView;
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
    UIImage *bgImage = [UIImage imageNamed:@"选择控件"];
    self.frame = CGRectMake(0, 0, bgImage.size.width + 20, bgImage.size.height); // none 20
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = bgImage;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.slideView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择控件-滑块"]];
    [self addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(80); // none
    }];
    
    self.chapterLabel = [[UILabel alloc] init];
    self.chapterLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.chapterLabel.text = @"章节";
    self.chapterLabel.textAlignment = NSTextAlignmentLeft;
    self.chapterLabel.font = [UIFont boldSystemFontOfSize:17];
    self.chapterLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.chapterLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.chapterLabel.layer.shadowOpacity = 1;
    self.chapterLabel.layer.shadowRadius = 0;
    
    self.pointLabel = [[UILabel alloc] init];
    self.pointLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
    self.pointLabel.text = @"知识点";
    self.pointLabel.textAlignment = NSTextAlignmentRight;
    self.pointLabel.font = [UIFont boldSystemFontOfSize:17];
    self.pointLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    self.pointLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.pointLabel.layer.shadowOpacity = 1;
    self.pointLabel.layer.shadowRadius = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.chapterLabel];
    [self addSubview:self.pointLabel];
    
    [self.chapterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28); //22
        make.centerY.mas_equalTo(0);
    }];
    
    [self.pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16); // -22
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    YXUserModel *userModel = [YXUserManager sharedManager].userModel;
    if ([userModel.stageName isEqualToString:@"小学"]
        || [userModel.stageName isEqualToString:@"初中"]) {
        if ([self.name isEqualToString:@"英语"]) {
            self.pointLabel.hidden = YES;
            self.userInteractionEnabled = NO;
        }
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
            self.chapterLabel.textColor = [UIColor colorWithHexString:@"805500"];
            self.chapterLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
            self.pointLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
            self.pointLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
            
            [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(4);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(80); // none
            }];
            [self layoutIfNeeded];
        }];
    }
    
    if (curSelectedIndex >= 1) {
        _curSelectedIndex = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.chapterLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
            self.chapterLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
            self.pointLabel.textColor = [UIColor colorWithHexString:@"805500"];
            self.pointLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
            
            [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-4);
                make.centerY.mas_equalTo(0);
                make.width.mas_equalTo(80); // none
            }];
            [self layoutIfNeeded];
        }];
    }
}

@end

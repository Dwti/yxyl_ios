//
//  YXPhotoSelectBottomView.m
//  YanXiuStudentApp
//
//  Created by wd on 15/9/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPhotoSelectBottomView.h"
#import "YXBottomGradientView.h"

@interface YXPhotoSelectBottomView ()
@property(nonatomic, strong) UILabel  * titleLabel;
@property(nonatomic, strong) UIButton * doneButton;
@end
@implementation YXPhotoSelectBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"008080"];
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.clipsToBounds = NO;
    
    @weakify(self);
    
    YXBottomGradientView *gView = [[YXBottomGradientView alloc] initWithFrame:CGRectZero color:[UIColor colorWithHexString:@"008080"]];

    [self addSubview:gView];
    [gView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(30);
        make.left.right.mas_equalTo(0);
    }];

    _doneButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor colorWithHexString:@"#00e6e6"] forState:UIControlStateDisabled];
    [_doneButton setTitleColor:[UIColor colorWithHexString:@"#ffdb4d"] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    _doneButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    _doneButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    _doneButton.titleLabel.layer.shadowOpacity = 1;
    _doneButton.titleLabel.layer.shadowRadius = 0;
    [self addSubview:_doneButton];
    [_doneButton setBackgroundImage:[UIImage imageNamed:@"完成btu"] forState:UIControlStateNormal];
    [_doneButton setBackgroundImage:[UIImage imageNamed:@"完成btu-按下"] forState:UIControlStateHighlighted];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self).with.offset(-5);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(61);
    }];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = @"已选择 0 张";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"005959"].CGColor;
    _titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    _titleLabel.layer.shadowOpacity = 1;
    _titleLabel.layer.shadowRadius = 0;

    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(150);
    }];
    
    _doneButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.doneHandle) {
            self.doneHandle();
        }
        return [RACSignal empty];
    }];
    _doneButton.enabled = NO;
}

- (void)reloadTitleWithInteger:(NSInteger)count
{
    self.titleLabel.text = [NSString stringWithFormat:@"已选择 %ld 张",(long)count];
    if (count > 0) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"ffdb4d"];
        self.doneButton.enabled = YES;
        
    }else{
        self.titleLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
        self.doneButton.enabled = NO;
    }
}
@end

//
//  UpdateAppAlertView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/20/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "UpdateAppPromptView.h"

@interface UpdateAppPromptView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) SimpleAlertButton *noButton;
@end

@implementation UpdateAppPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"新版本更新插画"];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(topImageView.image.size.width*kPhoneHeightRatio, topImageView.image.size.height*kPhoneHeightRatio));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(3);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    SimpleAlertButton *noButton = [[SimpleAlertButton alloc]init];
    noButton.style = SimpleAlertActionStyle_Cancel;
    [noButton addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noButton];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(50*kPhoneWidthRatio);
        make.bottom.mas_equalTo(-15);
    }];
    self.noButton = noButton;
    
    SimpleAlertButton *yesButton = [[SimpleAlertButton alloc]init];
    yesButton.style = SimpleAlertActionStyle_Default;
    [yesButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yesButton];
    [yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(noButton.mas_right).mas_offset(15);
        make.top.mas_equalTo(noButton.mas_top);
        make.bottom.mas_equalTo(noButton.mas_bottom);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(noButton.mas_width);
    }];
    UIImageView *greenImageView = [[UIImageView alloc]init];
    greenImageView.image = [UIImage imageNamed:@"新版本更新弹窗"];
    [self insertSubview:greenImageView atIndex:0];
    [greenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(124*kPhoneHeightRatio);
    }];
}

- (void)yesAction {
    BLOCK_EXEC(self.updateAction);
}

- (void)noAction {
    BLOCK_EXEC(self.cancelAction);
}

- (void)setBody:(YXInitRequestItem_Body *)body {
    _body = body;
    
    self.titleLabel.text = body.title;
    self.contentLabel.text = body.content;
    [self.titleLabel sizeToFit];
    [self.contentLabel sizeToFit];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleLabel.height);
    }];
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentLabel.height);
    }];
    
    if ([self.body isForce]) {
        [self.noButton setTitle:@"退出" forState:UIControlStateNormal];
    }else {
        [self.noButton setTitle:@"以后再说" forState:UIControlStateNormal];
    }
}

@end

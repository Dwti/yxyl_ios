//
//  ImageUploadProgressView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ImageUploadProgressView.h"

@interface ImageUploadProgressView ()
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) CloseBlock closeBlock;
@end

@implementation ImageUploadProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(235, 100));
    }];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:14];
    self.progressLabel.textColor = [UIColor whiteColor];
    [containerView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
    }];
    UIView *bgBarView = [[UIView alloc]init];
    bgBarView.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
    bgBarView.layer.cornerRadius = 3;
    bgBarView.clipsToBounds = YES;
    [containerView addSubview:bgBarView];
    [bgBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressLabel.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(6);
    }];
    self.progressBarView = [[UIView alloc]init];
    self.progressBarView.backgroundColor = [UIColor colorWithHexString:@"12b7f5"];
    self.progressBarView.layer.cornerRadius = 3;
    self.progressBarView.clipsToBounds = YES;
    [bgBarView addSubview:self.progressBarView];
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor whiteColor];
    [containerView addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgBarView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(0);
    }];
    self.promptLabel = promptLabel;
    self.closeButton = [[UIButton alloc]init];
    [self.closeButton setImage:[UIImage imageNamed:@"关闭取消按钮"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self updateWithUploadedCount:0 totalCount:0];
    self.type = ImageUpload_Submit;
}

- (void)updateWithUploadedCount:(NSInteger)uploadedCount totalCount:(NSInteger)totalCount {
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@",@(uploadedCount),@(totalCount)];
    CGFloat progress = 0.f;
    if (totalCount > 0) {
        progress = (CGFloat)uploadedCount/(CGFloat)totalCount;
    }
    [self.progressBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.progressBarView.superview.mas_width).multipliedBy(progress);
    }];
}

- (void)setType:(ImageUploadType)type {
    _type = type;
    if (type == ImageUpload_Submit) {
        self.promptLabel.text = @"提交作业图片中";
        self.closeButton.hidden = YES;
    }else if (type == ImageUpload_Save) {
        self.promptLabel.text = @"保存作业图片中";
        self.closeButton.hidden = NO;
    }
}

- (void)setupCloseBlock:(CloseBlock)block {
    self.closeBlock = block;
}

#pragma mark - Actions
- (void)closeAction {
    BLOCK_EXEC(self.closeBlock);
}

@end

//
//  QAImageUploadProgressView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAImageUploadProgressView.h"
@interface QAImageUploadProgressView ()
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIImageView *progressTipImgView;
@end

@implementation QAImageUploadProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(327, 202));
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"作业提交保存进度条背景"]];
    [containerView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.font = [UIFont systemFontOfSize:16];
    self.promptLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.promptLabel.text = @"作业图片提交中...";
    [containerView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_top).mas_offset(30);
        make.centerX.mas_equalTo(0);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:24];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"336600"];
    [containerView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.promptLabel.mas_bottom).mas_offset(15.0f);
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *bgBarView = [[UIView alloc]init];
    bgBarView.backgroundColor = [UIColor whiteColor];
    bgBarView.layer.cornerRadius = 3;
    bgBarView.clipsToBounds = YES;
    [containerView addSubview:bgBarView];
    [bgBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(255, 6));
    }];
    self.progressBarView = [[UIView alloc]init];
    self.progressBarView.backgroundColor = [UIColor colorWithHexString:@"336600"];
    self.progressBarView.layer.cornerRadius = 3;
    self.progressBarView.clipsToBounds = YES;
    [bgBarView addSubview:self.progressBarView];
    
    self.progressTipImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"铅笔进度条"]];
    [containerView addSubview:self.progressTipImgView];

    [self updateWithUploadedCount:0 totalCount:0];
}

- (void)updateWithUploadedCount:(NSInteger)uploadedCount totalCount:(NSInteger)totalCount {
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@",@(uploadedCount),@(totalCount)];
    self.progressLabel.attributedText = [self uploadProgress:[NSString stringWithFormat:@"%@",@(uploadedCount)] withTotal:[NSString stringWithFormat:@"%@",@(totalCount)]];
    CGFloat progress = 0.f;
    if (totalCount > 0) {
        progress = (CGFloat)uploadedCount/(CGFloat)totalCount;
    }
    [self.progressBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.progressBarView.superview.mas_width).multipliedBy(progress);
    }];
    [self.progressTipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressBarView.mas_right).mas_offset(-6);
        make.bottom.mas_equalTo(self.progressBarView.mas_top);
        make.size.mas_equalTo(CGSizeMake(30, 46));
    }];
}

- (NSMutableAttributedString *)uploadProgress:(NSString *)uploadedCount withTotal:(NSString *)totalCount{
    uploadedCount = !isEmpty(uploadedCount) ? uploadedCount : @"00";
    totalCount = !isEmpty(totalCount) ? totalCount : @"00";
    NSString *temString = [NSString stringWithFormat:@"%@ / %@",uploadedCount,totalCount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:temString];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Medium size:24],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"336600"]} range:NSMakeRange(0, [temString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Light size:24],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"336600"]} range:NSMakeRange(0, uploadedCount.length + 3)];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Medium size:24],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"336600"]} range:NSMakeRange(0, uploadedCount.length + 1)];
    return attributedString;
}

@end

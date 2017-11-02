//
//  QAAnalysisOralResultCell.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/26.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisOralResultCell.h"

@interface QAAnalysisOralResultCell ()
@property (nonatomic, strong) UILabel *notAnswerLabel;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation QAAnalysisOralResultCell

- (void)setupUI {
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.notAnswerLabel = [[UILabel alloc]init];
    self.notAnswerLabel.font = [UIFont boldSystemFontOfSize:27.0f];
    self.notAnswerLabel.textColor = [UIColor whiteColor];
    self.notAnswerLabel.text = @"未作答";
    [self.containerView addSubview:self.notAnswerLabel];
    [self.notAnswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(11.0f);
    }];
    
    self.backView = [[UIView alloc] init];
    [self.containerView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(11.0f);
        make.size.mas_equalTo(CGSizeMake(78, 24));
    }];
    self.backView.hidden = YES;
    
    self.leftImageView = [[UIImageView alloc] init];
    [self.backView addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.middleImageView = [[UIImageView alloc] init];
    [self.backView addSubview:self.middleImageView];
    [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.rightImageView = [[UIImageView alloc] init];
    [self.backView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)setHasAnswer:(BOOL)hasAnswer {
    _hasAnswer = hasAnswer;
    self.notAnswerLabel.hidden = hasAnswer;
    self.backView.hidden = !hasAnswer;
}

- (void)setOralScore:(NSString *)oralScore {
    _oralScore = oralScore;
    self.leftImageView.image = [UIImage imageNamed: [oralScore isEqualToString:@"0"] ? @"解析中页面小赞绿色" : @"解析中页面小赞红色"];
    self.middleImageView.image = [UIImage imageNamed: [oralScore isEqualToString:@"3"] || [oralScore isEqualToString:@"2"] ? @"解析中页面小赞红色" : @"解析中页面小赞绿色"];
    self.rightImageView.image = [UIImage imageNamed: [oralScore isEqualToString:@"3"] ? @"解析中页面小赞红色" : @"解析中页面小赞绿色"];
}

+ (CGFloat)height{
    return 82;
}

@end

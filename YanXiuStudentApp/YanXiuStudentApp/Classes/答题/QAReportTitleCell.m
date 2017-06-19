//
//  QAReportTitleCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportTitleCell.h"
#import "QAShadowLabel.h"

@interface QAReportTitleCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) QAShadowLabel *correctRateLabel;
@property (nonatomic, strong) QAShadowLabel *percentLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *totalCountLabel;
@property (nonatomic, strong) UILabel *correctCountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeDescLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation QAReportTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    
    self.bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分数报告背景"]];
    
        
    self.correctRateLabel = [[QAShadowLabel alloc]init];
    self.correctRateLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:55.0f];
    self.correctRateLabel.textColor = [UIColor colorWithHexString:@"336600"];
    
    self.percentLabel = [[QAShadowLabel alloc]init];
    self.percentLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:26.0f];
    self.percentLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.percentLabel.text = @"%";
    
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.descLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.descLabel.text = @"正确率";
    
    self.totalCountLabel = [[UILabel alloc]init];
    self.totalCountLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.totalCountLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    
    self.correctCountLabel = [[UILabel alloc]init];
    self.correctCountLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.correctCountLabel.textColor = [UIColor colorWithHexString:@"336600"];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.lineView.layer.cornerRadius = 1.0f;
    self.lineView.clipsToBounds = YES;
    
    self.timeDescLabel = [self.totalCountLabel clone];
    self.timeDescLabel.text = @"用时";
    
    self.durationLabel = [self.correctCountLabel clone];
}

- (void)setupLayout {
    [self addSubview:self.bgImageView];
    [self addSubview:self.correctRateLabel];
    [self addSubview:self.percentLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.totalCountLabel];
    [self addSubview:self.correctCountLabel];
    [self addSubview:self.timeDescLabel];
    [self addSubview:self.durationLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(375 * kPhoneWidthRatio, 370 *kPhoneWidthRatio));
    }];
    [self.correctRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.centerY.equalTo(self.bgImageView).offset(-20 *kPhoneWidthRatio);
    }];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.correctRateLabel.mas_right);
        make.centerY.equalTo(self.correctRateLabel);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.correctRateLabel);
        make.top.equalTo(self.correctRateLabel.mas_bottom);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView);
        make.bottom.mas_equalTo(-23.0f);
        make.size.mas_equalTo(CGSizeMake(2, 36));
    }];
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(-2.0f);
        make.right.equalTo(self.lineView.mas_left).offset(-20.0f);
    }];
    [self.correctCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalCountLabel.mas_bottom).offset(3.0f);
        make.right.equalTo(self.totalCountLabel);
    }];
    [self.timeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalCountLabel);
        make.left.equalTo(self.lineView.mas_right).offset(20.0f);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.correctCountLabel);
        make.left.equalTo(self.timeDescLabel);
    }];
}

- (void)setModel:(QAPaperModel *)model {
    _model = model;
    self.correctRateLabel.text = [NSString stringWithFormat:@"%.0f",model.correctRate*100];
    self.totalCountLabel.text = [NSString stringWithFormat:@"共%@题",@(model.totalQuestionNumber)];
    self.correctCountLabel.text = [NSString stringWithFormat:@"答对%@题",@([self resultCorrectCountWithModel:model])];
    self.durationLabel.text = [self formatTimeWithDuration:model.paperAnswerDuration];
}

- (NSInteger)resultCorrectCountWithModel:(QAPaperModel *)model {
    NSArray *questions = [model allQuestions];
    NSMutableArray *correctQuestionArray = [NSMutableArray array];
    for (QAQuestion *question in questions) {
        YXQAAnswerState state = [question answerState];
        if (state == YXAnswerStateCorrect) {
            [correctQuestionArray addObject:question];
        }
    }
    return correctQuestionArray.count;
}

- (NSString *)formatTimeWithDuration:(NSTimeInterval)duration {
    NSString *time = nil;
    int hour = duration/60/60;
    int min = (duration-hour*60*60)/60;
    int sec = duration-hour*60*60-min*60;
    time = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    return time;
}
@end

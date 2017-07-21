//
//  ExerciseHistoryListCell.m
//  YanXiuStudentApp
//
//  Created by LiuWenXing on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryListCell.h"

@interface ExerciseHistoryListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *finishTimeLabel;
@property (nonatomic, strong) UILabel *correctRateLabel;

@end

@implementation ExerciseHistoryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *whiteBackView = [[UIView alloc] init];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.layer.shadowOffset = CGSizeMake(0, 1);
    whiteBackView.layer.shadowRadius = 1;
    whiteBackView.layer.shadowOpacity = 0.02;
    whiteBackView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:whiteBackView];
    [whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *timeIconImageView = [[UIImageView alloc] init];
    timeIconImageView.image = [UIImage imageNamed:@"时间图标"];
    [self.contentView addSubview:timeIconImageView];
    [timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(15);
        make.bottom.mas_equalTo(whiteBackView.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    self.finishTimeLabel = [[UILabel alloc] init];
    self.finishTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.finishTimeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.finishTimeLabel];
    [self.finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeIconImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(timeIconImageView.mas_centerY);
    }];
    
    self.correctRateLabel = [[UILabel alloc] init];
    self.correctRateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.correctRateLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.correctRateLabel];
    [self.correctRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(timeIconImageView.mas_centerY);
    }];
}

- (void)setData:(YXGetPracticeHistoryItem_Data *)data {
    self.titleLabel.text = data.name;
    if ([data isFinished]) {
        self.finishTimeLabel.text = [NSString stringWithFormat:@"完成时间 %@", [self stringFromFinishiDate:data.buildTime]];
        self.correctRateLabel.text = [NSString stringWithFormat:@"正确率 %d%%", (int)roundf([data.correctNum floatValue] / [data.questionNum floatValue] * 100)];
    } else {
        self.finishTimeLabel.text = @"待完成";
        self.correctRateLabel.text = @"";
    }
}

- (NSString *)stringFromFinishiDate:(NSString *)finishiDate {
    NSString *dateString = [finishiDate componentsSeparatedByString:@" "].firstObject;
    NSMutableString *monthString = [NSMutableString stringWithString:[dateString componentsSeparatedByString:@"-"].firstObject];
    if ([monthString characterAtIndex:0] == '0') {
        [monthString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    NSMutableString *dayString = [NSMutableString stringWithString:[dateString componentsSeparatedByString:@"-"].lastObject];
    if ([dayString characterAtIndex:0] == '0') {
        [dayString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return [NSString stringWithFormat:@"%@月%@日", monthString, dayString];
}

@end

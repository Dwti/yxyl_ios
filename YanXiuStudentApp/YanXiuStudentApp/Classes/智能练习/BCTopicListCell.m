//
//  BCTopicListCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicListCell.h"
#import "BCTopicListFetcher.h"
#import "BCTopicPaper.h"

@interface BCTopicListCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *popularityLabel;
@property (nonatomic, strong) UILabel *correctRateLabel;
@property (nonatomic, strong) UIView *stateLineView;
@end

@implementation BCTopicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    UIView *containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.shadowOffset = CGSizeMake(0, 1);
    containerView.layer.shadowRadius = 1;
    containerView.layer.shadowOpacity = 0.02;
    containerView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    self.containerView = containerView;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    [containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(18);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(1);
    }];
    self.stateLineView = line;
    
    self.popularityLabel = [[UILabel alloc]init];
    self.popularityLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.popularityLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:self.popularityLabel];
    [self.popularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(line.mas_bottom).mas_offset(15);
    }];
    
    self.correctRateLabel = [self.popularityLabel clone];
    self.correctRateLabel.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:self.correctRateLabel];
    [self.correctRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.popularityLabel.mas_centerY);
        make.left.mas_equalTo(self.popularityLabel.mas_right).mas_offset(5);
    }];
    
    [self.popularityLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.popularityLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setTopicPaper:(BCTopicPaper *)topicPaper {
    _topicPaper = topicPaper;
    self.titleLabel.text = topicPaper.name;
    CGFloat viewNum = topicPaper.viewnum.floatValue;
    if (viewNum >= 10000) {
        viewNum = viewNum / 10000;
        self.popularityLabel.text = [NSString stringWithFormat:@"人气值 %.1f万",viewNum];
    }else {
        self.popularityLabel.text = [NSString stringWithFormat:@"人气值 %.0f",viewNum];
    }
    if (topicPaper.paperStatus) {
        if ([topicPaper.paperStatus.status isEqualToString:@"2"]) {//完成
            NSString *score = topicPaper.paperStatus.scoreRate;
            self.correctRateLabel.text = [NSString stringWithFormat:@"正确率 %.0f%@",score.floatValue*100,@"%"];
            self.correctRateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        }
    }else {
        NSString *answerState = [[YXQADataManager sharedInstance]loadPaperAnswerStateWithPaperID:topicPaper.rmsPaperId];
        if ([answerState isEqualToString:@"1"]) {
            self.correctRateLabel.text = @"作答中...";
            self.correctRateLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
        }else {
            self.correctRateLabel.text = @"";
            self.correctRateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        }
    }
}

@end

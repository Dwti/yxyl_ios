//
//  HomeworkListCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkListCell.h"

@interface HomeworkListCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *commentLineView;
@property (nonatomic, strong) UIView *stateLineView;
@property (nonatomic, strong) UIView *commentBgView;
@end

@implementation HomeworkListCell

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
    
    self.stateImageView = [[UIImageView alloc]init];
    self.stateImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    [containerView addSubview:self.stateImageView];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(17);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    [containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateImageView.mas_right).mas_offset(8);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(18);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(18);
        make.height.mas_equalTo(1);
    }];
    self.stateLineView = line;
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.stateLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(line.mas_bottom).mas_offset(20);
    }];
    self.descLabel = [self.stateLabel clone];
    self.descLabel.textAlignment = NSTextAlignmentRight;
    [containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.stateLabel.mas_centerY);
        make.left.mas_equalTo(self.stateLabel.mas_right).mas_offset(5);
    }];
    
    self.commentLineView = [[UIView alloc]init];
    self.commentLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [containerView addSubview:self.commentLineView];
    [self.commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(1);
    }];
    self.commentBgView = [[UIView alloc]init];
    self.commentBgView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    [containerView addSubview:self.commentBgView];
    [self.commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.commentLineView.mas_bottom);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.commentLabel.font = [UIFont systemFontOfSize:14];
    self.commentLabel.numberOfLines = 0;
    [self.commentBgView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
    [self.stateLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.stateLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setData:(YXHomework *)data {
    _data = data;
    self.titleLabel.text = data.name;
    if (data.paperStatus.status.intValue == 0) { //待完成
        [self hideComment];
        NSInteger answeredNum = [[YXQADataManager sharedInstance]loadPaperAnsweredQuestionNumWithPaperID:data.paperId];
        self.stateLabel.text = [NSString stringWithFormat:@"完成题量 %@/%@",@(answeredNum),data.quesnum];
        if (isEmpty(data.remaindertimeStr) || (data.remaindertimeStr.intValue <= 0)) {
            self.descLabel.text = @"可补做";
        }else{
            self.descLabel.text = [NSString stringWithFormat:@"剩余时间 %@",data.remaindertimeStr];
        }
    }else if (data.paperStatus.status.intValue == 1){ //未完成
        [self hideComment];
        self.stateLabel.text = @"逾期未交";
        self.descLabel.text = @"";
    }else if (data.paperStatus.status.intValue == 2){ //已完成
        if (data.subquesnum.integerValue == 0 || [data.paperStatus.teachercomments isEqualToString:@""] ) {
            [self hideComment];
            self.stateLabel.text = @"已批改";
            CGFloat scoreRate = data.paperStatus.scoreRate.floatValue;
            self.descLabel.text = [NSString stringWithFormat:@"正确率 %.0f%@",scoreRate*100,@"%"];
        }else {
            if (data.paperStatus.teachercomments.length) {
                self.stateLabel.text = @"已批改";
                CGFloat scoreRate = data.paperStatus.scoreRate.floatValue;
                self.descLabel.text = [NSString stringWithFormat:@"正确率 %.0f%@",scoreRate*100,@"%"];
                [self showComment];
                NSString *teacherString = [NSString stringWithFormat:@"%@评语：",data.paperStatus.teacherName];
                NSString *totalString = [NSString stringWithFormat:@"%@%@",teacherString,data.paperStatus.teachercomments];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:totalString];
                [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, teacherString.length)];
                self.commentLabel.attributedText = attrString;
            }else {
                [self hideComment];
                self.stateLabel.text = @"已完成，等待老师批改";
                self.descLabel.text = @"";
            }
        }
    }
}

- (void)hideComment {
    [self.commentLineView removeFromSuperview];
    [self.commentBgView removeFromSuperview];
    
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.stateLineView.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)showComment {
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.stateLineView.mas_bottom).mas_offset(20);
    }];
    [self.containerView addSubview:self.commentLineView];
    [self.containerView addSubview:self.commentBgView];
    [self.commentLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(1);
    }];
    [self.commentBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.commentLineView.mas_bottom);
    }];
}

@end

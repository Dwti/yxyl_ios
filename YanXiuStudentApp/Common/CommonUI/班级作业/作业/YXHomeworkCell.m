//
//  YXHomeworkCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkCell.h"
#import "YXDashLineCell.h"

@interface YXHomeworkCell ()

@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) YXDashLineCell *lineCell;

@end

@implementation YXHomeworkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)updateWithData:(YXHomeworkMock *)data {
    for (UIView *v in self.bottomLeftContainerView.subviews) {
        [v removeFromSuperview];
    }

    self.nameLabel.text = data.name;
    self.numberLabel.text = [NSString stringWithFormat:@"%@", @(data.total)];
    if (data.bDead) {
        self.timeLabel.text = @"已截止";
    } else {
        self.timeLabel.text = data.deadlineString;
    }
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.bottomLeftContainerView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    label.layer.shadowRadius = 0;
    [self.bottomLeftContainerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-5);
    }];

    iconImageView.image = [UIImage imageNamed:data.stateString];
    label.text = data.stateString;
    NSString *state = data.stateString;
    if ([state isEqualToString:@"未完成"]) {
        label.textColor = [UIColor colorWithHexString:@"007373"];
    }
    if ([state isEqualToString:@"待完成"]) {
        label.textColor = [UIColor colorWithHexString:@"b3476b"];
    }
    if ([state isEqualToString:@"已完成"]) {
        label.textColor = [UIColor colorWithHexString:@"805500"];
    }
    
    if ([data.rawData hasTeacherComments]) {
        [self.bottomContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.height.mas_equalTo(42);
            make.left.right.mas_equalTo(0);
        }];
        
        [self.bottomContainerView.superview addSubview:self.lineCell];
        [self.lineCell mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomContainerView.mas_bottom);
            make.left.mas_equalTo(4.f);
            make.right.mas_equalTo(-4.f);
            make.height.mas_equalTo(2);
        }];
        
        self.commentLabel.text = [NSString stringWithFormat:@"%@：%@", data.teacher, data.comment];
        [self.bottomContainerView.superview addSubview:self.commentLabel];
        [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineCell.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-15);
            make.right.mas_equalTo(-18);
            make.left.mas_equalTo(18);
        }];
    } else {
        [self.lineCell removeFromSuperview];
        [self.commentLabel removeFromSuperview];
    }
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.textColor = [UIColor colorWithHexString:@"805500"];
        _commentLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
        _commentLabel.layer.shadowOffset = CGSizeMake(0, 1);
        _commentLabel.layer.shadowOpacity = 1;
        _commentLabel.layer.shadowRadius = 0;
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}

- (YXDashLineCell *)lineCell
{
    if (!_lineCell) {
        _lineCell = [[YXDashLineCell alloc] init];
        _lineCell.realWidth = 4;
        _lineCell.dashWidth = 3;
        _lineCell.preferedGapToCellBounds = 3;
        _lineCell.bHasShadow = YES;
        _lineCell.realColor = [UIColor colorWithHexString:@"e4b62e"];
        _lineCell.shadowColor = [UIColor colorWithHexString:@"ffeb66"];
    }
    return _lineCell;
}

@end

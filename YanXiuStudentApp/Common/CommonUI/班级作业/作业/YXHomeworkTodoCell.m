//
//  YXHomeworkTodoCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkTodoCell.h"

@implementation YXHomeworkTodoCell

- (void)updateWithData:(YXHomework *)data {
    for (UIView *v in self.bottomLeftContainerView.subviews) {
        [v removeFromSuperview];
    }
    
    
    self.nameLabel.text = data.name;
    self.numberLabel.text = data.quesnum;
    if ([data.isEnd boolValue]) {
        self.timeLabel.text = @"已截止";
    } else {
        self.timeLabel.text = [data.overTime stringByAppendingString:@"截止"];
    }
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"科目";
    label.textColor = [UIColor colorWithHexString:@"ffdb4d"];
    label.backgroundColor = [UIColor colorWithHexString:@"805500"];
    label.font = [UIFont boldSystemFontOfSize:9];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    label.layer.shadowRadius = 0;
    [self.bottomLeftContainerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 18));
    }];
    
    UILabel *subjectLabel = [[UILabel alloc] init];
    subjectLabel.text = data.group.name;
    subjectLabel.textColor = [UIColor colorWithHexString:@"805500"];
    subjectLabel.backgroundColor = [UIColor clearColor];
    subjectLabel.font = [UIFont systemFontOfSize:13];
    subjectLabel.textAlignment = NSTextAlignmentLeft;
    subjectLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    subjectLabel.layer.shadowOffset = CGSizeMake(0, 1);
    subjectLabel.layer.shadowOpacity = 1;
    subjectLabel.layer.shadowRadius = 0;
    [self.bottomLeftContainerView addSubview:subjectLabel];
    [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_lessThanOrEqualTo(-5);
    }];
}

@end

//
//  YXQAAnalysisReportErrorCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisReportErrorCell_Pad.h"

@implementation YXQAAnalysisReportErrorCell_Pad


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    YXSmartDashLineView *line = [[YXSmartDashLineView alloc]init];
    line.dashWidth = 5;
    line.gapWidth = 2;
    line.lineColor = [UIColor colorWithHexString:@"ccc4a3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:@"题目有误，我要报错" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#b3ab8f"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"报错btu默认"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"报错btu点击"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(187, 40));
    }];
}

- (void)btnAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reportErrorViewClicked)]) {
        [self.delegate reportErrorViewClicked];
    }
}

+ (CGFloat)height{
    return 110;
}

@end

//
//  YXReportErrorCell.m
//  YanXiuStudentApp
//
//  Created by wd on 15/11/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXReportErrorCell.h"
#import "YXQADashLineView.h"

@interface YXReportErrorCell ()

@property (nonatomic, strong) UIButton   *reportErrorButton;

@end

@implementation YXReportErrorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setRAC];
    }
    return self;
}

- (void)setupViews
{
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    _reportErrorButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_reportErrorButton setTitle:@"题目有误，我要报错" forState:UIControlStateNormal];
    [_reportErrorButton setTitleColor:[UIColor colorWithHexString:@"#b3ab8f"] forState:UIControlStateNormal];
    [_reportErrorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _reportErrorButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_reportErrorButton setBackgroundImage:[UIImage imageNamed:@"报错btu默认"] forState:UIControlStateNormal];
    [_reportErrorButton setBackgroundImage:[UIImage imageNamed:@"报错btu点击"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_reportErrorButton];
    [_reportErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(187, 40));
    }];
}

- (void)setRAC
{
    @weakify(self);
    _reportErrorButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(reportErrorViewClicked)]) {
            [self.delegate performSelector:@selector(reportErrorViewClicked)];
        }
        return [RACSignal empty];
    }];
}

+ (CGFloat)height{
    return 110;
}

@end

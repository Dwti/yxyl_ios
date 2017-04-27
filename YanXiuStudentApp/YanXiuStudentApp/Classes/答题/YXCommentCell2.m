//
//  YXCommentCell2.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXCommentCell2.h"
#import "YXQADashLineView.h"
#import "YXQAUtils.h"
#import "YXStarRateView.h"

@interface YXCommentCell2()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) YXStarRateView *rateView;
@property (nonatomic, assign) BOOL uiUpdated;
@end

@implementation YXCommentCell2


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateUI{
    if (self.uiUpdated) {
        return;
    }
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    self.typeImageView.image = [UIImage imageNamed:[self.item typeString]];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    if (self.marked) {
        self.rateView = [[YXStarRateView alloc]initWithFrame:CGRectMake(0, 0, 95, 12)];
        [self.rateView updateWithDefaultImage:[UIImage imageNamed:@"批改结果icon-灰"] selectedImage:[UIImage imageNamed:@"批改结果icon-红"]];
        self.rateView.scorePercent = self.score;
        [self.contentView addSubview:self.rateView];
        [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
            make.size.mas_equalTo(CGSizeMake(95, 12));
        }];
    }else{
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = [UIFont systemFontOfSize:15];
        self.commentLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        self.commentLabel.text = @"未批改";
        [self.contentView addSubview:self.commentLabel];
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
        }];
    }
    self.uiUpdated = YES;
}

+ (CGFloat)heightForMarkStatus:(BOOL)marked score:(CGFloat)score comment:(NSString *)comment{
    CGFloat height = 30 + 18;
    CGFloat width = [UIScreen mainScreen].bounds.size.width-10-17-20*2-33-2-7-17*2;
    if (marked) {
        height += 15 + 12; // score
    }else{
        CGRect rect = [@"未批改" boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
        height += 15 + ceil(rect.size.height);
    }
    height += 10;

    return height;
}

@end

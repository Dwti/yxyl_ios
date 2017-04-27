//
//  YXQAAnalysisCommentCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAAnalysisCommentCell_Pad.h"
#import "YXStarRateView.h"
#import "YXQAUtils.h"

@interface YXQAAnalysisCommentCell_Pad()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) YXStarRateView *rateView;
@property (nonatomic, assign) BOOL uiUpdated;
@end

@implementation YXQAAnalysisCommentCell_Pad

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
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    self.typeImageView.image = [UIImage imageNamed:[self.item typeString]];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    if (self.marked) {
        self.rateView = [[YXStarRateView alloc]initWithFrame:CGRectMake(0, 0, 95, 12)];
        [self.rateView updateWithDefaultImage:[UIImage imageNamed:@"批改结果icon-灰"] selectedImage:[UIImage imageNamed:@"批改结果icon-红"]];
        self.rateView.scorePercent = self.score;
        [self.contentView addSubview:self.rateView];
        [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(39);
            make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
            make.size.mas_equalTo(CGSizeMake(95, 12));
        }];
        if (!isEmpty(self.comment)) {
            UIImage *teacherImage = [UIImage imageNamed:@"老师icon"];
            UIImageView *teacherView = [[UIImageView alloc]initWithImage:teacherImage];
            [self.contentView addSubview:teacherView];
            [teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(39);
                make.top.mas_equalTo(self.rateView.mas_bottom).mas_offset(15+8);
                make.size.mas_equalTo(teacherImage.size);
            }];
            
            UIImageView *commentBgView = [[UIImageView alloc]initWithImage:[YXQAUtils stemBgImage]];
            [self.contentView addSubview:commentBgView];
            [commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(teacherView.mas_right).mas_offset(2);
                make.top.mas_equalTo(self.rateView.mas_bottom).mas_offset(15).priorityHigh();
                make.right.mas_equalTo(-40);
                make.bottom.mas_equalTo(-10).priorityHigh();
            }];
            
            self.commentLabel = [[UILabel alloc] init];
            self.commentLabel.numberOfLines = 0;
            self.commentLabel.font = [UIFont systemFontOfSize:15];
            self.commentLabel.textColor = [UIColor colorWithHexString:@"#323232"];
            self.commentLabel.text = self.comment;
            [commentBgView addSubview:self.commentLabel];
            [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(17);
                make.left.mas_equalTo(24);
                make.bottom.mas_equalTo(-17);
                make.right.mas_equalTo(-17);
            }];
        }
    }else{
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = [UIFont systemFontOfSize:15];
        self.commentLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        self.commentLabel.text = @"未批改";
        [self.contentView addSubview:self.commentLabel];
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(39);
            make.right.mas_equalTo(-40);
            make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
        }];
    }
    
    self.uiUpdated = YES;
}

+ (CGFloat)heightForMarkStatus:(BOOL)marked score:(CGFloat)score comment:(NSString *)comment{
    CGFloat height = 30 + 18;
    CGFloat width = [UIScreen mainScreen].bounds.size.width-360-11-39-40-33-2-7-17*2;
    if (marked) {
        height += 15 + 12; // score
        if (!isEmpty(comment)) {
            CGRect rect = [comment boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
            height += 15 + 17*2 + ceil(rect.size.height);
        }
    }else{
        CGRect rect = [@"未批改" boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
        height += 15 + ceil(rect.size.height);
    }
    height += 10;
    
    return height;
}

@end

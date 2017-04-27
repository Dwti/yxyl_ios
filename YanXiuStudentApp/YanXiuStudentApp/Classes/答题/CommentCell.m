//
//  CommenCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/8/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "CommentCell.h"
#import "YXQADashLineView.h"

@interface CommentCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *commentLabel;
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

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
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
    }];
}

- (void)setItem:(YXQAAnalysisItem *)item {
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

- (void)updateUI {
    if (self.isMarked) {
        if (self.isCorrect) {
            self.commentLabel.text = @"正确";
        } else {
            self.commentLabel.text = @"错误";
        }
    } else {
        self.commentLabel.text = @"未批改";
    }
}

+ (CGFloat)heightForStatus {
    CGFloat height = 30 + 18;
    CGFloat width = [UIScreen mainScreen].bounds.size.width-10-17-20*2-33-2-7-17*2;
 
    CGRect rect = [@"对错" boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:NULL];
    
    height += 15 + ceil(rect.size.height);
    
    height += 10;
    
    return height;
}

@end

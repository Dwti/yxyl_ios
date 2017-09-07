//
//  MistakeSubjectCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeSubjectCell.h"

@interface MistakeSubjectCell()
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation MistakeSubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
        self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
        self.enterImageView.image = [UIImage imageNamed:@"展开内容按钮点击态"];
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
        self.enterImageView.image = [UIImage imageNamed:@"展开内容按钮正常态"];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.02;
    
    self.subjectLabel = [[UILabel alloc]init];
    self.subjectLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.subjectLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:self.subjectLabel];
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    UIImageView *enterImageView = [[UIImageView alloc]init];
    enterImageView.image = [UIImage imageNamed:@"展开内容按钮正常态"];
    [self.contentView addSubview:enterImageView];
    self.enterImageView = enterImageView;
    [enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(enterImageView.mas_left).mas_offset(-12);
        make.centerY.mas_equalTo(0);
    }];
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setShouldShowBottomLine:(BOOL)shouldShowBottomLine {
    _shouldShowBottomLine = shouldShowBottomLine;
    if (shouldShowBottomLine) {
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

- (void)setData:(GetSubjectMistakeRequestItem_subjectMistake *)data {
    _data = data;
    self.subjectLabel.text = data.name;
    NSString *countStr = [NSString stringWithFormat:@"%@题",data.data.wrongQuestionsCount];
    self.countLabel.text = countStr;
}

@end

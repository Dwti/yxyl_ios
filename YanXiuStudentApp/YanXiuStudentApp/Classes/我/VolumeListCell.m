//
//  VolumeListCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/8/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "VolumeListCell.h"

@interface VolumeListCell()
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *itemDetailLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end


@implementation VolumeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 0.02;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.itemImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.itemLabel = [[UILabel alloc]init];
    self.itemLabel.font = [UIFont boldSystemFontOfSize:16];
    self.itemLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.itemLabel];
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.itemImageView.mas_right).mas_offset(12);
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
    self.itemDetailLabel = [[UILabel alloc]init];
    self.itemDetailLabel.font = [UIFont systemFontOfSize:14];
    self.itemDetailLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    self.itemDetailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.itemDetailLabel];
    [self.itemDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(enterImageView.mas_left).mas_offset(-12);
        make.left.mas_equalTo(self.itemLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(0);
    }];
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.itemDetailLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.itemDetailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setShouldShowShadow:(BOOL)shouldShowShadow {
    _shouldShowShadow = shouldShowShadow;
    if (shouldShowShadow) {
        self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    }else {
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
    }
}

- (void)setSubject:(GetSubjectRequestItem_subject *)subject {
    _subject = subject;
    NSString *subjectName = subject.name;
    self.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon",subjectName]];
    self.itemLabel.text = subjectName;
    if (subject.edition.editionName) {
        self.itemDetailLabel.text = subject.edition.editionName;
        self.itemDetailLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    }else {
        self.itemDetailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.itemDetailLabel.text = @"未选择";
    }
}
@end

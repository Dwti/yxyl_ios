//
//  QAOralGradeCell.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralGradeCell.h"
#import "QAOralResultInStemView.h"

@interface QAOralGradeCell ()
@property (nonatomic, strong) QAOralResultInStemView *gradeView;
@end

@implementation QAOralGradeCell

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

#pragma mark - setupUI
- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    self.gradeView = [[QAOralResultInStemView alloc] init];
    [self.contentView addSubview:self.gradeView];
    [self.gradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(78, 24));
    }];
}

- (void)setResultItem:(QAOralResultItem *)resultItem {
    _resultItem = resultItem;
    self.gradeView.resultItem = resultItem;
}

@end

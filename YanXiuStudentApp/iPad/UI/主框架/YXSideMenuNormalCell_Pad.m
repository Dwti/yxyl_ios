//
//  YXSideMenuNormalCell_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSideMenuNormalCell_Pad.h"
#import "YXSmartDashLineView.h"

@interface YXSideMenuNormalCell_Pad()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YXSmartDashLineView *dashView;
@end

@implementation YXSideMenuNormalCell_Pad

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"ffdb4d"];
        [self.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"005959"]];
    }else{
        self.titleLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
        [self.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"005959"]];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.iconImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(29);
        make.top.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"00e6e6"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.titleLabel yx_setShadowWithColor:[UIColor colorWithHexString:@"005959"]];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
    
    YXSmartDashLineView *d1 = [[YXSmartDashLineView alloc]init];
    d1.dashWidth = 4;
    d1.gapWidth = 3;
    d1.lineColor = [UIColor colorWithHexString:@"006b6b"];
    d1.symmetrical = YES;
    [self.contentView addSubview:d1];
    [d1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-22);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    d1.layer.shadowColor = [UIColor colorWithHexString:@"009494"].CGColor;
    d1.layer.shadowOffset = CGSizeMake(0, 1);
    d1.layer.shadowRadius = 0;
    d1.layer.shadowOpacity = 1;
    
    self.dashView = d1;
}

- (void)setType:(YXSideMenuNormalCellType)type{
    _type = type;
    if (type == YXSideMenuRank) {
        self.titleLabel.text = @"排行榜";
        self.iconImageView.image = [UIImage yx_resizableImageNamed:@"排行icon"];
    }
//    else if (type == YXSideMenuFavor){
//        self.titleLabel.text = @"我的收藏";
//        self.iconImageView.image = [UIImage yx_resizableImageNamed:@"我的收藏icon"];
//    }
    else if (type == YXSideMenuHistory){
        self.titleLabel.text = @"练习历史";
        self.iconImageView.image = [UIImage yx_resizableImageNamed:@"练习历史icon"];
    }else if (type == YXSideMenuMistake){
        self.titleLabel.text = @"我的错题";
        self.iconImageView.image = [UIImage yx_resizableImageNamed:@"我的错题icon"];
    }else if (type == YXSideMenuSetting){
        self.titleLabel.text = @"设置";
        self.iconImageView.image = [UIImage yx_resizableImageNamed:@"设置icon"];
    }
}

- (void)setDashLineHidden:(BOOL)dashLineHidden{
    _dashLineHidden = dashLineHidden;
    self.dashView.hidden = dashLineHidden;
}

@end

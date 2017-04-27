//
//  YXQAWenHeaderView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAWenHeaderView_Pad.h"

@interface YXQAWenHeaderView_Pad()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@end

@implementation YXQAWenHeaderView_Pad

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    UIImage *bgImage = [UIImage yx_resizableImageNamed:@"题干展开背景"];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImage];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-40);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.textColor = [UIColor whiteColor];
    [bgImageView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    
    UIImage *typeBgImage = [UIImage yx_resizableImageNamed:@"题干展开题型背景"];
    UIImageView *typeImageView = [[UIImageView alloc]initWithImage:typeBgImage];
    [bgImageView addSubview:typeImageView];
    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indexLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(47, 23));
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"00cccc"];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.typeLabel yx_setShadowWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.1]];
    [typeImageView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)updateWithIndex:(NSInteger)index total:(NSInteger)total type:(NSString *)type{
    NSString *indexString = [NSString stringWithFormat:@"%@",@(index+1)];
    NSString *totalString = [NSString stringWithFormat:@"%@",@(total)];
    NSString *completeString = [NSString stringWithFormat:@"%@ /%@",indexString,totalString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:completeString];
    NSRange indexRange = [completeString rangeOfString:indexString];
    NSRange totalRange = [completeString rangeOfString:totalString options:NSBackwardsSearch];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Bold size:27]} range:indexRange];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Bold size:14]} range:totalRange];
    self.indexLabel.attributedText = attrString;
    self.typeLabel.text = type;
}

@end

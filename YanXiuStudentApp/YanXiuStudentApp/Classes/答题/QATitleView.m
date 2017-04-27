//
//  QATitleView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/13.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QATitleView.h"
#import "YXQADashLineView.h"

@interface QATitleView()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation QATitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(150, 16));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"b2a8bf"];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(13);
    }];
    
    YXQADashLineView *line = [[YXQADashLineView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title{
    if (title) {
        self.titleLabel.attributedText = [self attrbutedProgress:title];
    } else {
        self.titleLabel.text = title;
    }
}

- (void)setItem:(QAQuestion *)item{
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
    self.title = item.position.indexString;
}

- (NSAttributedString *)attrbutedProgress:(NSString *)title {
    
    NSString *indexString = [[title componentsSeparatedByString:@"/"] objectAtIndex:0];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange indexRange = [title rangeOfString:indexString];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Bold size:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"807c6c"]} range:indexRange];
    
    return attrString;
}

@end

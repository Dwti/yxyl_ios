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
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *indexLabel;
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
    self.backgroundColor = [UIColor whiteColor];
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.textColor = [UIColor colorWithHexString:@"666666"];
    self.indexLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:16];
    [self addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setTitle:(NSString *)title{
    if (title) {
        self.indexLabel.attributedText = [self attrbutedProgress:title];
    } else {
        self.indexLabel.text = title;
    }
}

- (void)setItem:(QAQuestion *)item{
    self.typeLabel.text = [item typeString];
    self.title = item.position.indexString;
}

- (NSAttributedString *)attrbutedProgress:(NSString *)title {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange slashRange = [title rangeOfString:@"/"];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Light size:16]} range:slashRange];
    
    return attrString;
}

@end

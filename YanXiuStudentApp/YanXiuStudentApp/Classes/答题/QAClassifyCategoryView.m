//
//  QAClassifyCategoryView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyCategoryView.h"

static const CGFloat kMinCategoryWidth = 90.f;

@interface QAClassifyCategoryView()
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *categoryBgView;
@end

@implementation QAClassifyCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.categoryBgView = [[UIView alloc]init];
    self.categoryBgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.categoryBgView.layer.cornerRadius = 6;
    [self addSubview:self.categoryBgView];
    [self.categoryBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    self.categoryLabel = [[UILabel alloc]init];
    self.categoryLabel.numberOfLines = 3;
    self.categoryLabel.font = [UIFont boldSystemFontOfSize:15];
    self.categoryLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    [self.categoryBgView addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    self.countLabel = [[UILabel alloc]init];
    self.countLabel.backgroundColor = [UIColor whiteColor];
    self.countLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:16];
    self.countLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.layer.cornerRadius = 17.5;
    self.countLabel.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    self.countLabel.layer.borderWidth = 3;
    self.countLabel.clipsToBounds = YES;
    [self addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    BLOCK_EXEC(self.clickBlock);
}

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    UIFont *font = nil;
    CGFloat lineSpacing = 0;
    if ([QAClassifyCategoryView shouldShow3LinesForCategory:categoryName]) {
        font = [UIFont boldSystemFontOfSize:11];
        lineSpacing = 2;
    }else {
        font = [UIFont boldSystemFontOfSize:15];
        lineSpacing = 5;
    }
    self.categoryLabel.font = font;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:categoryName attributes:dic];
    self.categoryLabel.attributedText = attrStr;
}

- (void)setOptionsCount:(NSInteger)optionsCount {
    _optionsCount = optionsCount;
    self.countLabel.text = [NSString stringWithFormat:@"%@",@(optionsCount)];
}

+ (CGFloat)widthForCategory:(NSString *)categoryName {
    return 120;
    
//    UILabel *helpLabel = [[UILabel alloc]init];
//    helpLabel.font = [UIFont boldSystemFontOfSize:15];
//    helpLabel.numberOfLines = 2;
//    helpLabel.text = @"jgiorejgojoerjgperh";
//    CGSize helpSize = [helpLabel sizeThatFits:CGSizeMake(40, 999)];
//    
//    UILabel *categoryLabel = [[UILabel alloc]init];
//    categoryLabel.text = categoryName;
//    categoryLabel.font = [UIFont boldSystemFontOfSize:15];
//    categoryLabel.numberOfLines = 0;
//    CGFloat width = kMinCategoryWidth;
//    CGSize size = [categoryLabel sizeThatFits:CGSizeMake(width, 99999)];
//    while (size.height > helpSize.height) {
//        width += 10.f;
//        size = [categoryLabel sizeThatFits:CGSizeMake(width, 99999)];
//    }
//    return width+30+10;
}

+ (BOOL)shouldShow3LinesForCategory:(NSString *)categoryName {
    UILabel *categoryLabel = [[UILabel alloc]init];
    categoryLabel.text = categoryName;
    categoryLabel.font = [UIFont boldSystemFontOfSize:15];
    categoryLabel.numberOfLines = 2;
    CGFloat width = kMinCategoryWidth;
    CGSize size = [categoryLabel sizeThatFits:CGSizeMake(width, 99999)];
    
    categoryLabel.numberOfLines = 3;
    CGSize size2 = [categoryLabel sizeThatFits:CGSizeMake(width, 99999)];
    
    if (size2.height > size.height) {
        return YES;
    }
    return NO;
}

@end

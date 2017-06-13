//
//  QAQuestionIndexDetailView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAQuestionIndexDetailView.h"

@interface QAQuestionIndexDetailView ()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation QAQuestionIndexDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:21];
    self.lineView = [[UIView alloc]init];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:16];
    
    [self addSubview:self.indexLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.detailLabel];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 1));
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(4);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setDetailString:(NSString *)detailString {
    _detailString = detailString;
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@",@"(",detailString,@")"];
}

- (void)setIndexString:(NSString *)indexString {
    _indexString = indexString;
    self.indexLabel.text = indexString;
}

- (void)setColorString:(NSString *)colorString {
    _colorString = colorString;
    self.indexLabel.textColor = [UIColor colorWithHexString:colorString];
    self.lineView.backgroundColor = [UIColor colorWithHexString:colorString];
    self.detailLabel.textColor = [UIColor colorWithHexString:colorString];
}


@end

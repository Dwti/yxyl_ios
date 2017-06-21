//
//  QASubjectiveStemBlankView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveStemBlankView.h"

@interface QASubjectiveStemBlankView()
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation QASubjectiveStemBlankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-2, self.width, 2)];
    line.backgroundColor = [UIColor colorWithHexString:@"4c4c4c"];
    line.layer.cornerRadius = 1;
    line.clipsToBounds = YES;
    [self addSubview:line];
    self.indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    self.indexLabel.center = CGPointMake(self.width/2, self.height-8-1-2);
    self.indexLabel.backgroundColor = [UIColor colorWithHexString:@"4c4c4c"];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont fontWithName:YXFontArialNarrow_Bold size:15];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.layer.cornerRadius = 8;
    self.indexLabel.clipsToBounds = YES;
    [self addSubview:self.indexLabel];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%@",@(index)];
}

- (void)setIndexHidden:(BOOL)indexHidden {
    _indexHidden = indexHidden;
    self.indexLabel.hidden = indexHidden;
}

@end

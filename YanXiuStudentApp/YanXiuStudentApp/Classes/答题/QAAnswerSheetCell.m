//
//  QAAnswerSheetCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnswerSheetCell.h"
#import "QAQuestionNumberButton.h"

NSString * const kQASelectedQuestionNotification = @"kQASelectedQuestionNotification";
NSString * const kQASelectedQuestionKey = @"kQASelectedQuestionKey";

@interface QAAnswerSheetCell ()
@property (nonatomic, strong) QAQuestionNumberButton *itemButton;
@end


@implementation QAAnswerSheetCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.itemButton = [[QAQuestionNumberButton alloc]init];
    WEAK_SELF
    [self.itemButton setClickActionBlock:^{
        STRONG_SELF
        [[NSNotificationCenter defaultCenter]postNotificationName:kQASelectedQuestionNotification object:nil userInfo:@{kQASelectedQuestionKey:self.item}];
    }];
    [self addSubview:self.itemButton];
    [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setHasWrote:(BOOL)hasWrote {
    _hasWrote = hasWrote;
    if (hasWrote) {
        self.itemButton.imageName = @"答题卡已做题背景";
        self.itemButton.textColor = [UIColor colorWithHexString:@"89e00d"];
        self.itemButton.highlightedTextColor = [UIColor whiteColor];
    }else {
        self.itemButton.imageName = @"答题卡未做题背景";
        self.itemButton.textColor = [UIColor colorWithHexString:@"999999"];
        self.itemButton.highlightedTextColor = [UIColor whiteColor];
    }
}

- (void)setItem:(QAQuestion *)item {
    _item = item;
    self.itemButton.title = item.position.indexDetailString;;
}

@end

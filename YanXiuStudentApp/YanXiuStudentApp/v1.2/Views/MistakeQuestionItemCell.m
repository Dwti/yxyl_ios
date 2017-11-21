//
//  MistakeQuestionItemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeQuestionItemCell.h"
#import "QAQuestionNumberButton.h"

NSString * const kQASelectedMiatakeQuestionNotification = @"kQASelectedMiatakeQuestionNotification";
NSString * const kQASelectedMistakeQuestionKey = @"kQASelectedMistakeQuestionKey";

@interface MistakeQuestionItemCell ()
@property (nonatomic, strong) QAQuestionNumberButton *itemButton;
@end


@implementation MistakeQuestionItemCell

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
        [[NSNotificationCenter defaultCenter]postNotificationName:kQASelectedMiatakeQuestionNotification object:nil userInfo:@{kQASelectedMistakeQuestionKey:self.item}];
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
    NSString *title = [NSString stringWithFormat:@"%@",@(item.position.firstLevelIndex+1)];
    self.itemButton.title = title;
}

@end


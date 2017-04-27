//
//  YXClassesView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/8/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassesView.h"
#import "YXQAConnectGroupView.h"
#import "YXQAConnectStateManager.h"
#import "YXQAConnectLineView.h"

@interface YXQAGroupItems : NSObject
@property (nonatomic, strong) YXQAConnectGroupView *view;
@property (nonatomic, assign) CGFloat height;
@end
@implementation YXQAGroupItems
@end

@interface YXClassesView()

@end

@implementation YXClassesView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(QAQuestion *)item{
    if (self.item) {
        return;
    }
    _item = item;
    
    if (self.groupArray) {
        [self setupGroups];
    }else{
        self.groupArray = [NSMutableArray array];
        for (int i = 0; i < item.myAnswers.count;) {
            QANumberGroupAnswer *leftQuestion = item.myAnswers[i];
            QANumberGroupAnswer *rightQuestion;
            if (i + 1 < item.myAnswers.count) {
                rightQuestion = item.myAnswers[i + 1];
            }

            NSString *l = [self.class titleWithItem:leftQuestion];
            NSString *r = rightQuestion? [self.class titleWithItem:rightQuestion]: nil;
            CGFloat height = [YXQAConnectGroupView heightForLeftContent:l rightContent:r];
            YXQAConnectGroupView *v = [[YXQAConnectGroupView alloc]init];
            [v updateWithLeftContent:l rightContent:r];
            YXQAGroupItems *group = [[YXQAGroupItems alloc]init];
            group.view = v;
            group.height = height;
            [self.groupArray addObject:group];
            i += 2;
        }
        [self setupGroups];
    }
}

#pragma mark-
- (void)reloadData
{
    for (int i = 0; i < self.item.myAnswers.count;) {
        QANumberGroupAnswer *leftQuestion = self.item.myAnswers[i];
        QANumberGroupAnswer *rightQuestion;
        if (i + 1 < self.item.myAnswers.count) {
            rightQuestion = self.item.myAnswers[i + 1];
        }
        
        YXQAGroupItems *group = self.groupArray[i / 2];
        YXQAConnectGroupView *v = group.view;
        NSString *l = [self.class titleWithItem:leftQuestion];
        NSString *r = rightQuestion? [self.class titleWithItem:rightQuestion]: nil;
        CGFloat height = [YXQAConnectGroupView heightForLeftContent:l rightContent:r];
        [v updateWithLeftContent:l rightContent:r];
        group.height = height;
        i += 2;
    }
}

+ (NSString *)titleWithItem:(QANumberGroupAnswer *)item
{
    long total = 0;
    for (NSNumber *result in item.answers) {
        if (result.longLongValue) {
            total++;
        }
    }
    return [NSString stringWithFormat:@"%@（%ld）", item.name, total];
}

- (void)setupGroups{
    [self.groupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXQAGroupItems *item = (YXQAGroupItems *)obj;
        YXQAConnectGroupView *view = item.view;
        UITapGestureRecognizer *leftTap = [UITapGestureRecognizer new];
        WEAK_SELF
        [[leftTap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            NSInteger index = (int)idx * 2;
            if (self.touchClasses) {
                self.touchClasses(index);
            }
        }];
        UITapGestureRecognizer *rightTap = [UITapGestureRecognizer new];
        [[rightTap rac_gestureSignal] subscribeNext:^(id x) {
            STRONG_SELF
            NSInteger index = (int)idx * 2 + 1;
            if (self.touchClasses) {
                self.touchClasses(index);
            }
        }];
        [view.leftView addGestureRecognizer:leftTap];
        [view.rightView addGestureRecognizer:rightTap];
        [self addSubview:view];
        if (idx == 0) {
            [item.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(item.height);
            }];
        }else{
            YXQAGroupItems *group = self.groupArray[idx-1];
            [item.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(group.view.mas_left);
                make.right.mas_equalTo(group.view.mas_right);
                make.top.mas_equalTo(group.view.mas_bottom).mas_offset(20);
                make.height.mas_equalTo(item.height);
            }];
        }
    }];
}

+ (CGFloat)heightForItem:(QAQuestion *)item{
    CGFloat totalHeight = 0.f;
    for (int i = 0; i < item.myAnswers.count;) {
        QANumberGroupAnswer *leftQuestion = item.myAnswers[i];
        QANumberGroupAnswer *rightQuestion;
        if (i + 1 < item.myAnswers.count) {
            rightQuestion = item.myAnswers[i + 1];
        }
        NSString *l = [self titleWithItem:leftQuestion];
        NSString *r = rightQuestion? [self titleWithItem:rightQuestion]: nil;
        CGFloat height = [YXQAConnectGroupView heightForLeftContent:l rightContent:r];
        totalHeight += height+20;
        i += 2;
    }
    return totalHeight;
}

@end

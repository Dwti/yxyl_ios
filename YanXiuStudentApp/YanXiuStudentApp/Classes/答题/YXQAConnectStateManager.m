//
//  YXQAConnectStateManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/10.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAConnectStateManager.h"

@interface YXQAConnectStateManager()

@end

@implementation YXQAConnectStateManager
- (instancetype)init{
    if (self = [super init]) {
        self.itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)setup{
    [self refreshState];
    for (YXQAConnectItemView *v in self.itemArray) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [v addGestureRecognizer:tap];
    }
}

- (void)refreshState{
    for (YXQAConnectItemView *v in self.itemArray) {
        v.state = YXQAConnectStateDefault;
    }
    [self.item.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QANumberGroupAnswer *answer = (QANumberGroupAnswer *)obj;
        [answer.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *n = (NSNumber *)obj;
            YXQAConnectItemView *v = self.itemArray[idx];
            if (n.boolValue) {
                v.state = YXQAConnectStateConnected;
            }
        }];
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture{
    YXQAConnectItemView *v = (YXQAConnectItemView *)gesture.view;
    if (v.state == YXQAConnectStateSelected) {
        NSInteger index = [self.itemArray indexOfObject:v];
        if ([self hasConnectionForIndex:index]) {
            v.state = YXQAConnectStateConnected;
        }else{
            v.state = YXQAConnectStateDefault;
        }
    }else if (v.state == YXQAConnectStateDefault || v.state == YXQAConnectStateConnected){
        YXQAConnectItemView *selected = nil;
        for (YXQAConnectItemView *view in self.itemArray) {
            if (view.state == YXQAConnectStateSelected) {
                selected = view;
                break;
            }
        }
        if (!selected) {
            v.state = YXQAConnectStateSelected;
        }else{
            NSInteger curIndex = [self.itemArray indexOfObject:v];
            NSInteger selectIndex = [self.itemArray indexOfObject:selected];
            if ([self isInSameColumnForIndex:curIndex anotherIndex:selectIndex]) { // in same column
                if ([self hasConnectionForIndex:selectIndex]) {
                    selected.state = YXQAConnectStateConnected;
                }else{
                    selected.state = YXQAConnectStateDefault;
                }
                v.state = YXQAConnectStateSelected;
            }else{
                [self clearConnectionForIndex:selectIndex];
                [self clearConnectionForIndex:curIndex];
                NSInteger groupIndex = MIN(curIndex, selectIndex);
                QANumberGroupAnswer *answer = self.item.myAnswers[groupIndex];
                answer.answers[curIndex] = @(YES);
                answer.answers[selectIndex] = @(YES);
                [self refreshState];
                BLOCK_EXEC(self.refreshBlock);
            }
        }
    }
}

- (BOOL)isInSameColumnForIndex:(NSInteger)index anotherIndex:(NSInteger)anotherIndex{
    BOOL p1 = index < self.itemArray.count/2;
    BOOL p2 = anotherIndex < self.itemArray.count/2;
    return p1 == p2;
}

- (void)clearConnectionForIndex:(NSInteger)index{
    [self.item.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QANumberGroupAnswer *answer = (QANumberGroupAnswer *)obj;
        NSNumber *n = answer.answers[index];
        if (n.boolValue) {
            for (int i=0; i<answer.answers.count; i++) {
                [answer.answers replaceObjectAtIndex:i withObject:@(NO)];
            }
            *stop = YES;
        }
    }];
}

- (BOOL)hasConnectionForIndex:(NSInteger)index{
    __block BOOL hasConnection = NO;
    [self.item.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QANumberGroupAnswer *answer = (QANumberGroupAnswer *)obj;
        NSNumber *n = answer.answers[index];
        if (n.boolValue) {
            hasConnection = YES;
            *stop = YES;
        }
    }];
    return hasConnection;
}

@end

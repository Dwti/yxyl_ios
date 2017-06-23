//
//  QAAnalysisAudioCommentCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisAudioCommentCell.h"
#import "AudioItemView.h"
#import "AudioCommentManager.h"

CGFloat const kAudioViewHeihgt0 = 45;
CGFloat const kAudioViewGap0 = 10;

@interface QAAnalysisAudioCommentCell ()
@property (nonatomic, strong) AudioCommentManager *manager;

@end

@implementation QAAnalysisAudioCommentCell

- (void)dealloc
{
    [self stop];
}

- (void)setupAudioItemView {
    self.manager = [[AudioCommentManager alloc] init];
    
    
    for (int i = 0; i < self.questionItem.audioComments.count; i++) {
        
        AudioItemView *item = [[AudioItemView alloc] init];
        item.tag = i;
        item.audioComment = self.questionItem.audioComments[i];
        
        [self.containerView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(kAudioViewHeihgt0);
            make.top.equalTo(self.containerView).offset(i * (kAudioViewHeihgt0 + kAudioViewGap0) + 13);
        }];
        
        [self.manager.itemArray addObject:item];
    }
    
    [self.manager setup];
}

- (void)stop {
    [self.manager stopPlayAll];
}

- (void)setQuestionItem:(QAQuestion *)questionItem {
    _questionItem = questionItem;
    
    if (!self.manager) {
        [self setupAudioItemView];
    }
}

+ (CGFloat)heightForAudioComment:(NSArray *)array {
    CGFloat height = 15 + 14 + 15 + array.count * kAudioViewHeihgt0 + (array.count - 1)* kAudioViewGap0 + 15;
    return height;
}

@end

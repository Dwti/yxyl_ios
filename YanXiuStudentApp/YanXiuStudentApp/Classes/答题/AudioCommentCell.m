//
//  audioCommentCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/22/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "AudioCommentCell.h"
#import "AudioItemView.h"
#import "AudioCommentManager.h"
#import "YXQADashLineView.h"

CGFloat const kAudioViewHeihgt = 29;
CGFloat const kAudioViewGap = 15;

@interface AudioCommentCell ()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) AudioCommentManager *manager;
@end

@implementation AudioCommentCell

- (void)dealloc
{    
    [self stop];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];

    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    

}

- (void)setupAudioItemView {
    self.manager = [[AudioCommentManager alloc] init];

    for (int i = 0; i < self.questionItem.audioComments.count; i++) {
        AudioItemView *item = [[AudioItemView alloc] init];
        item.tag = i;
        item.audioComment = self.questionItem.audioComments[i];
        
        [self.contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(kAudioViewHeihgt);
            make.top.equalTo(self.typeImageView.mas_bottom).offset(i * (kAudioViewHeihgt + kAudioViewGap) + kAudioViewGap);
        }];
        
        [self.manager.itemArray addObject:item];
    }
    
    [self.manager setup];
}

- (void)stop {
    [self.manager stopPlayAll];
}

- (void)setAnalysisItem:(YXQAAnalysisItem *)analysisItem {
    _analysisItem = analysisItem;
    self.typeImageView.image = [UIImage imageNamed:[analysisItem typeString]];
}

- (void)setQuestionItem:(QAQuestion *)questionItem {
    _questionItem = questionItem;
    
    if (!self.manager) {
        [self setupAudioItemView];
    }
}

+ (CGFloat)heightForAudioComment:(NSArray *)array {
    return array.count * (kAudioViewGap + kAudioViewHeihgt) + kAudioViewGap + 30 + 10;
}

@end

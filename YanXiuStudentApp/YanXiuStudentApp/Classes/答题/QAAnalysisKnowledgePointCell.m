//
//  QAAnalysisKnowledgePointCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAnalysisKnowledgePointCell.h"
#import "QAKnowledgePointView.h"

@interface QAAnalysisKnowledgePointCell ()
@property (nonatomic, strong) QAKnowledgePointView *knowledgePointView;

@end
@implementation QAAnalysisKnowledgePointCell

- (void)setupUI{
    [super setupUI];
    
    self.knowledgePointView = [[QAKnowledgePointView alloc]init];
    [self.containerView addSubview:self.knowledgePointView];
    [self.knowledgePointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setKnowledgePointArray:(NSArray *)knowledgePointArray {
    _knowledgePointArray = knowledgePointArray;
    NSMutableArray *array = [NSMutableArray array];
    for (QAKnowledgePoint *p in knowledgePointArray) {
        [array addObject:p.name];
    }
    self.knowledgePointView.dataArray = [NSArray arrayWithArray:array];
}

- (CGFloat)heightWithKnowledgePointArray:(NSArray *)array {
    NSMutableArray *pointArray = [NSMutableArray array];
    for (QAKnowledgePoint *p in array) {
        [pointArray addObject:p.name];
    }
    return [self.knowledgePointView heightWithDataArray:[NSArray arrayWithArray:pointArray]];
}
@end

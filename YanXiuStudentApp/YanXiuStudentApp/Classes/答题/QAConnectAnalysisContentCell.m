//
//  QAConnectAnalysisContentCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectAnalysisContentCell.h"
#import "QAConnectAnalysisGroupView.h"
#import "QAConnectAnalysisLineView.h"
#import "QAConnectOptionInfo.h"

@interface QAGroupItem : NSObject
@property (nonatomic, strong) QAConnectAnalysisGroupView *groupView;
@property (nonatomic, assign) CGFloat height;
@end
@implementation QAGroupItem
@end

@interface QAConnectAnalysisContentCell()<YXHtmlCellHeightDelegate>

@property (nonatomic, strong) QAConnectAnalysisLineView *connectLineView;
@property (nonatomic, assign) CGFloat totalHeight;
@property (nonatomic, copy) CellHeightChangeBlock block;

@end

@implementation QAConnectAnalysisContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.totalHeight = 0;
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setItem:(QAQuestion *)item{
    if (_item == item) {
        return;
    }
    _item = item;
    
    NSMutableArray<QAConnectOptionInfo *> *allOptionInfoArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *option in item.options) {
        QAConnectOptionInfo *info = [[QAConnectOptionInfo alloc]init];
        info.option = option;
        info.index = index;
        info.isCorrect = NO;
        [allOptionInfoArray addObject:info];
        index++;
    }
    
    for (int i = 0; i < item.myAnswers.count; i++) {
        QANumberGroupAnswer *myAnswer = item.myAnswers[i];
        NSMutableArray *pairArray = [NSMutableArray array];
        [myAnswer.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *num = (NSNumber *)obj;
            if (num.boolValue) {
                [pairArray addObject:@(idx)];
            }
        }];
        if (pairArray.count == 2) {
            NSInteger first = ((NSNumber *)pairArray.firstObject).integerValue;
            NSInteger last = ((NSNumber *)pairArray.lastObject).integerValue;
            QAConnectOptionInfo *leftInfo = allOptionInfoArray[first];
            QAConnectOptionInfo *rightInfo = allOptionInfoArray[last];
            QANumberGroupAnswer *correctAnswer = item.correctAnswers[i];
            if ([self isSameWithMyAnswer:myAnswer correctAnswer:correctAnswer]) {
                leftInfo.isCorrect = YES;
                rightInfo.isCorrect = YES;
            }
        }
    }
    
    if (self.groupArray) {
        [self setupGroups];
    }else{
        self.groupArray = [NSMutableArray array];
        NSInteger groupCount = item.options.count/2;
        for (int i = 0; i < groupCount; i++) {
            NSString *l = item.options[i];
            NSString *r = item.options[i+groupCount];
            CGFloat height = [QAConnectAnalysisGroupView heightForLeftContent:l rightContent:r];
            QAConnectAnalysisGroupView *v = [[QAConnectAnalysisGroupView alloc]init];
            [v updateWithLeftContent:l rightContent:r];
            
            QAConnectOptionInfo *leftInfo = allOptionInfoArray[i];
            QAConnectOptionInfo *rightInfo = allOptionInfoArray[i + groupCount];
            if (leftInfo.isCorrect) {
                v.leftView.answerState = YXAnswerStateCorrect;
            }else{
                v.leftView.answerState = YXAnswerStateWrong;
            }
            if (rightInfo.isCorrect) {
                v.rightView.answerState = YXAnswerStateCorrect;
            }else {
                v.rightView.answerState = YXAnswerStateWrong;
            }
            QAGroupItem *group = [[QAGroupItem alloc]init];
            group.groupView = v;
            group.height = height;
            [self.groupArray addObject:group];
        }
        [self setupGroups];
    }
    
    self.connectLineView = [[QAConnectAnalysisLineView alloc]init];
    self.connectLineView.item = self.item;
    [self.contentView addSubview:self.connectLineView];
    [self.connectLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(55);
    }];
    [self refreshConnectLineView];
}

- (BOOL)isSameWithMyAnswer:(QANumberGroupAnswer *)myAnswer correctAnswer:(QANumberGroupAnswer *)correctAnswer{
    __block BOOL isSame = YES;
    [myAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *correct = correctAnswer.answers[idx];
        if (obj.boolValue != correct.boolValue) {
            isSame = NO;
            *stop = YES;
        }
    }];
    return isSame;
}
//- (void)executeRedoStatusDelegate {
//    if (self.redoStatusDelegate && [self.redoStatusDelegate respondsToSelector:@selector(updateRedoStatus)]) {
//        [self.redoStatusDelegate updateRedoStatus];
//    }
//}

- (void)setupGroups{
    NSMutableArray *leftArray = [NSMutableArray array];
    NSMutableArray *rightArray = [NSMutableArray array];
    [self.groupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAGroupItem *item = (QAGroupItem *)obj;
        item.groupView.delegate = self;
        [self.contentView addSubview:item.groupView];
        if (idx == 0) {
            [item.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(item.height);
            }];
        }else{
            QAGroupItem *group = self.groupArray[idx-1];
            [item.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(group.groupView.mas_left);
                make.right.mas_equalTo(group.groupView.mas_right);
                make.top.mas_equalTo(group.groupView.mas_bottom).mas_offset(20);
                make.height.mas_equalTo(item.height);
            }];
        }
        [leftArray addObject:item.groupView.leftView];
        [rightArray addObject:item.groupView.rightView];
    }];
    for (QAGroupItem *item in self.groupArray) {
        self.totalHeight += item.height+20;
    }
}

- (void)refreshConnectLineView{
    CGFloat height = 0.f;
    NSMutableArray *positionArray = [NSMutableArray array];
    for (QAGroupItem *group in self.groupArray) {
        QAConnectPosition *p = [[QAConnectPosition alloc]init];
        p.position = group.height/2 + height;
        [positionArray addObject:p];
        height += group.height+20;
    }
    self.connectLineView.positionArray = positionArray;
    [self.connectLineView setNeedsDisplay];
}

+ (CGFloat)heightForItem:(QAQuestion *)item{
    CGFloat totalHeight = 0.f;
    NSInteger groupCount = item.options.count/2;
    for (int i = 0; i < groupCount; i++) {
        NSString *l = item.options[i];
        NSString *r = item.options[i+groupCount];
        CGFloat height = [QAConnectAnalysisGroupView heightForLeftContent:l rightContent:r];
        totalHeight += height+20;
    }
    return totalHeight;
}

#pragma mark - for 解析
- (void)setShowAnalysisAnswers:(BOOL)showAnalysisAnswers{
    _showAnalysisAnswers = showAnalysisAnswers;
    self.connectLineView.showAnalysisAnswers = showAnalysisAnswers;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    NSInteger index = 0;
    QAGroupItem *group = nil;
    for (int i=0; i<self.groupArray.count; i++) {
        QAGroupItem *item = self.groupArray[i];
        if (item.groupView == (UIView *)cell) {
            index = i;
            group = item;
            break;
        }
    }
    group.height = height;
    [self refreshConnectLineView];
    if (index == 0) {
        [group.groupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(group.height);
        }];
    }else{
        QAGroupItem *preGroup = self.groupArray[index-1];
        [group.groupView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(preGroup.groupView.mas_left);
            make.right.mas_equalTo(preGroup.groupView.mas_right);
            make.top.mas_equalTo(preGroup.groupView.mas_bottom).mas_offset(20);
            make.height.mas_equalTo(group.height);
        }];
    }
    CGFloat totalHeight = 0.f;
    for (QAGroupItem *item in self.groupArray) {
        totalHeight += item.height+20;
    }
    if (self.totalHeight < totalHeight) {
        self.totalHeight = totalHeight;
        BLOCK_EXEC(self.block,totalHeight);
    }
}

- (void)setCellHeightChangeBlock:(CellHeightChangeBlock)block {
    self.block = block;
}
@end

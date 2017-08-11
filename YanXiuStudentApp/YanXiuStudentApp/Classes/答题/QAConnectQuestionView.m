//
//  QAConnectQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionView.h"
#import "QAQuestionStemCell.h"
#import "QAComplexHeaderCellDelegate.h"
#import "QAComplexHeaderFactory.h"
#import "QAConnectContentCell.h"
#import "QAConnectContentView.h"
#import "QAConnectOptionInfo.h"
#import "QAConnectSelectedView.h"
#import "QAConnectSelectedCell.h"
#import "QAConnectOptionsView.h"
#import "QABaseViewController.h"

static const CGFloat kBottomViewHeight = 77.f;
static const CGFloat kOffect = 16.f;

@interface QAConnectQuestionView ()
@property (nonatomic, strong) QAConnectContentView *optionsView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *graycircleView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *switchView;
@property (nonatomic, strong) QAConnectSelectedView *alreadyConnectedView;
@property (nonatomic, strong) AlertView *alertView;

@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *allOptionInfoArray;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *leftOptionInfoArray;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *rightOptionInfoArray;
@end

@implementation QAConnectQuestionView

- (void)leaveForeground {
    [super leaveForeground];
    SAFE_CALL(self.headerCell, leaveForeground);
}

- (void)setData:(QAQuestion *)data {
    [super setData:data];
    self.allOptionInfoArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *option in self.data.options) {
        QAConnectOptionInfo *info = [[QAConnectOptionInfo alloc]init];
        info.option = option;
        info.index = index;
        QAConnectContentCell *cell = [[QAConnectContentCell alloc]init];
        cell.optionInfo = info;
        info.size = [cell defaultSize];
        [self.allOptionInfoArray addObject:info];
        index++;
    }
    
    for (QANumberGroupAnswer *groupAnswer in data.myAnswers) {
        [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                self.allOptionInfoArray[idx].selected = YES;
            }
        }];
    }
    
    self.leftOptionInfoArray = [NSMutableArray array];
    self.rightOptionInfoArray = [NSMutableArray array];
    NSInteger groupCount = self.allOptionInfoArray.count/2;
    for (int i = 0; i < groupCount; i++) {
        QAConnectOptionInfo *leftInfo = self.allOptionInfoArray[i];
        QAConnectOptionInfo *rightInfo = self.allOptionInfoArray[i + groupCount];
        [self.leftOptionInfoArray addObject:leftInfo];
        [self.rightOptionInfoArray addObject:rightInfo];
    }
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    return heightArray;
}

- (void)setupUI {
    [super setupUI];
    
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self updateTableViewLayout];
    self.backgroundColor = [UIColor whiteColor];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kBottomViewHeight);
    }];
    
    self.graycircleView = [[UIImageView alloc]init];
    self.graycircleView.image = [UIImage imageNamed:@"灰底"];
    [self addSubview:self.graycircleView];
    [self.graycircleView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-kBottomViewHeight - 21);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(85, 46));
    }];
    
    self.optionsView = [[QAConnectContentView alloc]init];
    [self.optionsView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
    WEAK_SELF
    [self.optionsView setSelectedTwinOptionActionBlock:^(QAConnectOptionInfo *leftOptionInfo, QAConnectOptionInfo *rightOptionInfo) {
        STRONG_SELF
        [self putSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        
    }];
    [self addSubview:self.optionsView];
    [self.optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-27.f);
    }];
    
    self.maskView = [[UIView alloc]initWithFrame:self.window.bounds];
    [self.window addSubview:self.maskView];
    self.maskView.hidden = YES;
    
    self.switchView = [QABaseViewController currentSwitchBarSnapshotView];
    
    self.alreadyConnectedView = [[QAConnectSelectedView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -kBottomViewHeight - kOffect - 55 , SCREEN_WIDTH, SCREEN_HEIGHT-15)];
    [self loadSelectedViewData];
    [self setupAlreadyConnectedViewBlock];
    [self addSubview:self.alreadyConnectedView];
    
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.alertView.hideWhenMaskClicked = NO;
    [self.alertView setHideBlock:^(AlertView *view){
        STRONG_SELF
        [UIView animateWithDuration:.3 animations:^{
            self.alreadyConnectedView.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomViewHeight - kOffect, SCREEN_WIDTH, SCREEN_HEIGHT-15);
        }completion:^(BOOL finished) {
            [view removeFromSuperview];
            self.alreadyConnectedView.isFold = YES;
            [self addSubview:self.alreadyConnectedView];
            self.alreadyConnectedView.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomViewHeight - kOffect - 55, SCREEN_WIDTH, SCREEN_HEIGHT-15);
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT, self.switchView.width, self.switchView.height);
        }];
    }];
}

- (void)updateTableViewLayout {
    CGFloat tableHeight = 0.f;
    for (NSNumber *num in self.cellHeightArray) {
        tableHeight += num.floatValue;
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(tableHeight);
    }];
}

- (void)putSelectedOptionsWithLeftOption:(QAConnectOptionInfo *)leftInfo rightOption:(QAConnectOptionInfo *)rightInfo {
    leftInfo.selected = YES;
    rightInfo.selected = YES;
    
    YXQAAnswerState fromState = [self.data answerState];
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[leftInfo.index];
    [groupAnswer.answers replaceObjectAtIndex:leftInfo.index withObject:@(YES)];
    [groupAnswer.answers replaceObjectAtIndex:rightInfo.index withObject:@(YES)];
    [self.data saveAnswer];
    WEAK_SELF
    [self showConnectAnimationWithLeftOption:leftInfo rightOption:rightInfo completeBlock:^{
        STRONG_SELF
        [self.optionsView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
        
        QAConnectTwinOptionInfo *info = [[QAConnectTwinOptionInfo alloc]init];
        info.leftOptionInfo = leftInfo;
        info.rightOptionInfo = rightInfo;
        info.height = [QAConnectSelectedCell heightForTwinOption:info];
        [self.alreadyConnectedView.optionInfoArray addObject:info];
        [self.alreadyConnectedView reloadData];
        
        YXQAAnswerState toState = [self.data answerState];
        if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
        }
    }];
}

- (void)showConnectAnimationWithLeftOption:(QAConnectOptionInfo *)leftInfo rightOption:(QAConnectOptionInfo *)rightInfo completeBlock:(void(^)())completeBlock {
    CGPoint p = [self.optionsView.rightView.tableView convertPoint:self.optionsView.rightView.tableView.contentOffset toView:self.window];
    
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, p.y, self.window.bounds.size.width, self.window.bounds.size.height - p.y)];
    containerView.clipsToBounds = YES;
    [self.window addSubview:containerView];
    
    NSMutableArray *imageViewArray = [NSMutableArray array];
    
    CGRect leftOriFrame = leftInfo.frame;
    if (CGRectGetMaxY(leftOriFrame)<self.optionsView.leftView.tableView.contentOffset.y) {
        leftOriFrame.origin.y += self.optionsView.leftView.tableView.contentOffset.y-CGRectGetMaxY(leftOriFrame);
    }else if (leftOriFrame.origin.y > self.optionsView.leftView.tableView.contentOffset.y+self.optionsView.leftView.tableView.frame.size.height) {
        leftOriFrame.origin.y = self.optionsView.leftView.tableView.contentOffset.y+self.optionsView.leftView.tableView.frame.size.height;
    }
    leftOriFrame = [self.optionsView.leftView.tableView convertRect:leftOriFrame toView:containerView];
    UIImageView *leftCellImageView = [[UIImageView alloc]initWithFrame:leftOriFrame];
    leftCellImageView.image = leftInfo.snapshotImage;
    [containerView addSubview:leftCellImageView];
    [imageViewArray addObject:leftCellImageView];
    
    CGRect rightOriFrame = rightInfo.frame;
    if (CGRectGetMaxY(rightOriFrame)<self.optionsView.rightView.tableView.contentOffset.y) {
        rightOriFrame.origin.y += self.optionsView.rightView.tableView.contentOffset.y-CGRectGetMaxY(rightOriFrame);
    }else if (rightOriFrame.origin.y > self.optionsView.rightView.tableView.contentOffset.y+self.optionsView.rightView.tableView.frame.size.height) {
        rightOriFrame.origin.y = self.optionsView.rightView.tableView.contentOffset.y+self.optionsView.rightView.tableView.frame.size.height;
    }
    rightOriFrame = [self.optionsView.rightView.tableView convertRect:rightOriFrame toView:containerView];
    UIImageView *rightCellImageView = [[UIImageView alloc]initWithFrame:rightOriFrame];
    rightCellImageView.image = rightInfo.snapshotImage;
    [containerView addSubview:rightCellImageView];
    [imageViewArray addObject:rightCellImageView];
    
    CGPoint basketCenter = [self.alreadyConnectedView.foldButton convertPoint:CGPointMake(CGRectGetWidth(self.alreadyConnectedView.foldButton.bounds)/2, CGRectGetHeight(self.alreadyConnectedView.foldButton.bounds)/2) toView:containerView];
    [self openBasket];
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        for (UIImageView *view in imageViewArray) {
            view.frame = CGRectMake(basketCenter.x-20, basketCenter.y-20, 40, 40);
            view.alpha = 0.2f;
        }
    } completion:^(BOOL finished) {
        [containerView removeFromSuperview];
        [self closeBasket];
        BLOCK_EXEC(completeBlock);
    }];
}

- (void)openBasket {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alreadyConnectedView.foldButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:nil];
}

- (void)closeBasket {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alreadyConnectedView.foldButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)loadSelectedViewData {
    for (QANumberGroupAnswer *groupAnswer in self.data.myAnswers) {
        __block NSMutableArray *answerArray = [NSMutableArray array];
        [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                [answerArray addObject:@(idx)];
            }
        }];
        if (answerArray.count == 2) {
            QAConnectTwinOptionInfo *info = [[QAConnectTwinOptionInfo alloc]init];
            info.leftOptionInfo = [self.allOptionInfoArray objectAtIndex:[answerArray.firstObject integerValue]];
            info.rightOptionInfo = [self.allOptionInfoArray objectAtIndex:[answerArray.lastObject integerValue]];
            info.height = [QAConnectSelectedCell heightForTwinOption:info];
            [self.alreadyConnectedView.optionInfoArray addObject:info];
            [self.alreadyConnectedView reloadData];
        }
    }
}

- (void)setupAlreadyConnectedViewBlock {
    WEAK_SELF
    [self.alreadyConnectedView setFoldActionBlock:^{
        STRONG_SELF
        if (self.alreadyConnectedView.isFold) {
            [self unfoldSelectedView];
        }else {
            [self foldSelectedView];
        }
    }];
    
    [self.alreadyConnectedView setDragUpBlock:^(CGFloat offset) {
        STRONG_SELF
        if (self.maskView.hidden) {
            self.maskView.hidden = NO;
            [self.window insertSubview:self.alreadyConnectedView aboveSubview:self.maskView];
            self.alreadyConnectedView.frame = CGRectMake(0, SCREEN_HEIGHT -kBottomViewHeight - kOffect , SCREEN_WIDTH, SCREEN_HEIGHT-15);
            if (!self.switchView) {
                self.switchView = [QABaseViewController currentSwitchBarSnapshotView];
                [self.window addSubview:self.switchView];
            }
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT - self.switchView.height, self.switchView.width, self.switchView.height);
        }
        self.alreadyConnectedView.y = MAX(self.alreadyConnectedView.y+offset, 15);
        DDLogDebug(@"self.selectedView.y = %@",@(self.alreadyConnectedView.y));
        CGFloat rate = (self.alreadyConnectedView.y-15)/(SCREEN_HEIGHT-15);
        self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6*(1.f-rate)];
        CGFloat margin = SCREEN_HEIGHT - kBottomViewHeight - kOffect - self.alreadyConnectedView.y;
        if (margin >= self.switchView.height && margin <= 2*self.switchView.height) {
            [self.window bringSubviewToFront:self.switchView];
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT - 2 *self.switchView.height + margin, SCREEN_WIDTH, self.switchView.height);
        }
        if (margin > 2*self.switchView.height) {
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.switchView.height);
        }
    }];
    
    [self.alreadyConnectedView setDragDownBlock:^(CGFloat offset){
        STRONG_SELF
        self.alreadyConnectedView.y = MIN(self.alreadyConnectedView.y+offset, SCREEN_HEIGHT-kBottomViewHeight - kOffect);
        CGFloat rate = (self.alreadyConnectedView.y-15)/(SCREEN_HEIGHT-15);
        self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6*(1.f-rate)];
        CGFloat margin = SCREEN_HEIGHT - kBottomViewHeight - kOffect - self.alreadyConnectedView.y;
        if (margin >= self.switchView.height && margin <= 2*self.switchView.height) {
            [self.window bringSubviewToFront:self.switchView];
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT - 2*self.switchView.height + margin, SCREEN_WIDTH, self.switchView.height);
        }
        if (margin > 2*self.switchView.height) {
            self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.switchView.height);
        }
    }];
    
    [self.alreadyConnectedView setDeleteActionBlock:^(QAConnectTwinOptionInfo *twinOption) {
        STRONG_SELF
        QAConnectOptionInfo *leftOptionInfo = twinOption.leftOptionInfo;
        QAConnectOptionInfo *rightOptionInfo = twinOption.rightOptionInfo;
        [self removeSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        [self.alreadyConnectedView.optionInfoArray removeObject:twinOption];
        [self.alreadyConnectedView reloadData];
    }];
    
    [self.alreadyConnectedView setDeleteAllActionBlock:^(NSMutableArray<QAConnectTwinOptionInfo *> *optionInfoArray) {
        STRONG_SELF
        for (QAConnectTwinOptionInfo *twinOption in optionInfoArray) {
            QAConnectOptionInfo *leftOptionInfo = twinOption.leftOptionInfo;
            leftOptionInfo.selected = NO;
            QAConnectOptionInfo *rightOptionInfo = twinOption.rightOptionInfo;
            rightOptionInfo.selected = NO;
            [self removeSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        }
        [self.alreadyConnectedView.optionInfoArray removeAllObjects];
        [self.alreadyConnectedView reloadData];
    }];
}

- (void)unfoldSelectedView {
    self.alreadyConnectedView.isFold = NO;
    self.maskView.hidden = YES;
    self.switchView.frame = CGRectMake(0, SCREEN_HEIGHT, self.switchView.width, self.switchView.height);
    self.alertView.contentView = self.alreadyConnectedView;
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    [self.alertView showInView:self.window withLayout:^(AlertView *view) {
        [UIView animateWithDuration:.3 animations:^{
            self.alreadyConnectedView.frame = CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT-15);
        }];
    }];
}

- (void)foldSelectedView {
    [self.alertView hide];
}

- (void)removeSelectedOptionsWithLeftOption:(QAConnectOptionInfo *)leftInfo rightOption:(QAConnectOptionInfo *)rightInfo {
    YXQAAnswerState fromState = [self.data answerState];
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[leftInfo.index];
    [groupAnswer.answers replaceObjectAtIndex:leftInfo.index withObject:@(NO)];
    [groupAnswer.answers replaceObjectAtIndex:rightInfo.index withObject:@(NO)];
    [self.data saveAnswer];
    
    [self.optionsView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
    
    YXQAAnswerState toState = [self.data answerState];
    if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
        [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
            self.headerCell = cell;
        }
        return cell;
    }
    if (self.hideQuestion) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
    cell.delegate = self;
    cell.bottomLineHidden = YES;
    [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
    return cell;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    [super tableViewCell:cell updateWithHeight:height];
    [self updateTableViewLayout];
}

- (UIImage *)imageFromView:(UIView *)view {
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

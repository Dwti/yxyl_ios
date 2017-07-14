//
//  YXQAClassifyView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyQuestionView.h"
#import "QAQuestionStemCell.h"
#import "QAClassifyOptionCell.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "QAClassifyOptionInfo.h"
#import "QAClassifyCategoryView.h"
#import "QAClassifyPopupView.h"
#import "QAComplexHeaderCellDelegate.h"
#import "QAComplexHeaderFactory.h"

@interface QAClassifyQuestionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) DTAttributedLabel *stemLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<QAClassifyCategoryView *> *categoryViewArray;
@property (nonatomic, strong) NSMutableArray<QAClassifyOptionInfo *> *optionInfoArray;
@property (nonatomic, strong) NSMutableArray<QAClassifyOptionInfo *> *allOptionInfoArray;
@property (nonatomic, strong) QAClassifyPopupView *popupView;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic,strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;
@end

@implementation QAClassifyQuestionView
- (void)leaveForeground {
    [super leaveForeground];
    SAFE_CALL(self.headerCell, leaveForeground);
}

- (void)setData:(QAQuestion *)data {
    [super setData:data];
    self.allOptionInfoArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *option in self.data.options) {
        QAClassifyOptionInfo *info = [[QAClassifyOptionInfo alloc]init];
        info.option = option;
        info.index = index;
        QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:option];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = NO"];
    NSArray *array = [self.allOptionInfoArray filteredArrayUsingPredicate:predicate];
    self.optionInfoArray = [NSMutableArray arrayWithArray:array];
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

- (void)setupUI{    
    [super setupUI];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self updateTableViewLayout];
    
    UIView *optionsBgView = [[UIView alloc]init];
    optionsBgView.backgroundColor = [UIColor whiteColor];
    optionsBgView.layer.shadowOffset = CGSizeMake(0, 2.5);
    optionsBgView.layer.shadowRadius = 2.5;
    optionsBgView.layer.shadowOpacity = 0.02;
    optionsBgView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self addSubview:optionsBgView];
    [optionsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(-10);
        make.bottom.mas_equalTo(-155);
    }];
    
    CollectionViewEqualSpaceFlowLayout *layout = [[CollectionViewEqualSpaceFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [optionsBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-25);
    }];
    QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:self.optionInfoArray.firstObject.option];
    [self.collectionView registerClass:[cell class] forCellWithReuseIdentifier:@"OptionCell"];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.height-155, self.width, 110)];
    [self addSubview:scrollView];
    __block QAClassifyCategoryView *view_1;
    __block QAClassifyCategoryView *view_2;
    __block CGFloat x = 20.f;
    self.categoryViewArray = [NSMutableArray array];
    [self.data.correctAnswers enumerateObjectsUsingBlock:^(QANumberGroupAnswer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [QAClassifyCategoryView widthForCategory:obj.name];
        QAClassifyCategoryView *view = [[QAClassifyCategoryView alloc]initWithFrame:CGRectMake(x, 5, width, 90)];
        view.categoryName = obj.name;
        view.optionsCount = [self optionsCountForCategoryIndex:idx];
        WEAK_SELF
        [view setClickBlock:^{
            STRONG_SELF
            if ([self hasSelectedOptions]) {
                [self putSelectedOptionsToCategoryIndex:idx];
            }else {
                [self showPopupViewForCategoryIndex:idx];
            }
        }];
        [scrollView addSubview:view];
        [self.categoryViewArray addObject:view];
        x += width+20;
        if (idx==0) {
            view_1 = view;
        }else if (idx==1){
            view_2 = view;
        }
    }];
    if (self.data.correctAnswers.count==2 && view_1.width+view_2.width+20*3<scrollView.width) {
        x = (scrollView.width-(view_1.width+view_2.width+20))/2;
        view_1.frame = CGRectMake(x, view_1.y, view_1.width, view_1.height);
        view_2.frame = CGRectMake(x+view_1.width+20, view_2.y, view_2.width, view_2.height);
        scrollView.contentSize = CGSizeMake(scrollView.width, scrollView.height);
    }else {
        scrollView.contentSize = CGSizeMake(x, 110);
    }
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

- (NSInteger)optionsCountForCategoryIndex:(NSInteger)index {
    NSInteger count = 0;
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
    for (NSNumber *num in groupAnswer.answers) {
        if (num.boolValue) {
            count++;
        }
    }
    return count;
}

- (BOOL)hasSelectedOptions {
    for (QAClassifyOptionInfo *info in self.optionInfoArray) {
        if (info.selected) {
            return YES;
        }
    }
    return NO;
}

- (void)putSelectedOptionsToCategoryIndex:(NSInteger)index {
    YXQAAnswerState fromState = [self.data answerState];
    
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
    for (QAClassifyOptionInfo *info in self.optionInfoArray) {
        if (info.selected) {
            [groupAnswer.answers replaceObjectAtIndex:info.index withObject:@(YES)];
        }
    }
    NSInteger count = 0;
    for (NSNumber *num in groupAnswer.answers) {
        if (num.boolValue) {
            count++;
        }
    }
    self.categoryViewArray[index].optionsCount = count;
    [self.data saveAnswer];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = NO"];
    NSArray *array = [self.optionInfoArray filteredArrayUsingPredicate:predicate];
    self.optionInfoArray = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
    
    YXQAAnswerState toState = [self.data answerState];
    if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
        [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
    }
}

- (void)showPopupViewForCategoryIndex:(NSInteger)index {
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.alertView.hideWhenMaskClicked = NO;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view){
        STRONG_SELF
        [UIView animateWithDuration:.3 animations:^{
            self.popupView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-15);
        }completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    if (!self.popupView) {
        self.popupView = [[QAClassifyPopupView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-15)];
    }
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
    self.popupView.categoryName = groupAnswer.name;
    self.popupView.optionInfoArray = [self optionInfoArrayForCategoryIndex:index];
    [self.popupView setFoldBlock:^{
        STRONG_SELF
        [self.alertView hide];
    }];
    [self.popupView setDeleteBlock:^(QAClassifyOptionInfo *info){
        STRONG_SELF
        [self removeOption:info fromCategoryIndex:index];
    }];
    self.alertView.contentView = self.popupView;
    [self.alertView showInView:self.window withLayout:^(AlertView *view) {
        [UIView animateWithDuration:.3 animations:^{
            self.popupView.frame = CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT-15);
        }];
    }];
}

- (NSMutableArray *)optionInfoArrayForCategoryIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
    [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.boolValue) {
            [array addObject:self.allOptionInfoArray[idx]];
        }
    }];
    return array;
}

- (void)removeOption:(QAClassifyOptionInfo *)optionInfo fromCategoryIndex:(NSInteger)index {
    YXQAAnswerState fromState = [self.data answerState];
    
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
    [groupAnswer.answers replaceObjectAtIndex:optionInfo.index withObject:@(NO)];
    self.categoryViewArray[index].optionsCount = self.categoryViewArray[index].optionsCount-1;
    [self.data saveAnswer];
    
    optionInfo.selected = NO;
    __block NSInteger insertIndex = self.optionInfoArray.count;
    [self.optionInfoArray enumerateObjectsUsingBlock:^(QAClassifyOptionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.index > optionInfo.index) {
            insertIndex = idx;
            *stop = YES;
        }
    }];
    [self.optionInfoArray insertObject:optionInfo atIndex:insertIndex];
    [self.collectionView reloadData];
    
    YXQAAnswerState toState = [self.data answerState];
    if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
        [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.optionInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAClassifyOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionCell" forIndexPath:indexPath];
    WEAK_SELF
    [cell setSizeChangedBlock:^(CGSize size){
        STRONG_SELF
        if (!CGSizeEqualToSize(size, self.optionInfoArray[indexPath.row].size)){
            self.optionInfoArray[indexPath.row].size = size;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];
    cell.optionString = self.optionInfoArray[indexPath.row].option;
    cell.selected = self.optionInfoArray[indexPath.row].selected;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.optionInfoArray[indexPath.row].size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.optionInfoArray[indexPath.row].selected = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.optionInfoArray[indexPath.row].selected = NO;
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
    [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
    return cell;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    [super tableViewCell:cell updateWithHeight:height];
    [self updateTableViewLayout];
}

@end


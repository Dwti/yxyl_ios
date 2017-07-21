//
//  QAClassifyAnswerResultCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClassifyAnswerResultCell.h"
#import "QAClassifyOptionCell.h"
#import "QAClassifyOptionInfo.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "QAClassifyAnswerGroupHeaderView.h"

@interface QAClassifyAnswerResultGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, strong) NSArray<QAClassifyOptionInfo *> *optionInfoArray;
@end
@implementation QAClassifyAnswerResultGroup
@end

@interface QAClassifyAnswerResultCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<QAClassifyAnswerResultGroup *> *groupArray;
@end

@implementation QAClassifyAnswerResultCell

+ (CGFloat)heightForQuestion:(QAQuestion *)question {
    QAClassifyAnswerResultCell *cell = [[QAClassifyAnswerResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.question = question;
    cell.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [cell layoutIfNeeded];
    return cell.collectionView.contentSize.height-10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CollectionViewEqualSpaceFlowLayout *layout = [[CollectionViewEqualSpaceFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 35, 5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.allowsSelection = NO;
    self.collectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.collectionView registerClass:[QAClassifyAnswerGroupHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAClassifyAnswerGroupHeaderView"];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.collectionView rac_valuesAndChangesForKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew observer:self]subscribeNext:^(id x) {
        STRONG_SELF
        [self.delegate tableViewCell:self updateWithHeight:self.collectionView.contentSize.height-10];
    }];
}

- (void)setQuestion:(QAQuestion *)question {
    if (_question == question) {
        return;
    }
    _question = question;
    NSMutableArray<QAClassifyOptionInfo *> *allOptionInfoArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *option in question.options) {
        QAClassifyOptionInfo *info = [[QAClassifyOptionInfo alloc]init];
        info.option = option;
        info.index = index;
        QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:option];
        info.size = [cell defaultSize];
        [allOptionInfoArray addObject:info];
        index++;
    }
    self.groupArray = [NSMutableArray array];
    for (int i=0; i<question.myAnswers.count; i++) {
        QANumberGroupAnswer *myAnswer = question.myAnswers[i];
        QANumberGroupAnswer *correctAnswer = question.correctAnswers[i];
        NSMutableArray *array = [NSMutableArray array];
        [myAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                QAClassifyOptionInfo *info = allOptionInfoArray[idx];
                info.selected = YES;
                NSNumber *num = correctAnswer.answers[idx];
                if (num.boolValue) {
                    info.isCorrect = YES;
                }
                [array addObject:info];
            }
        }];
//        if (array.count > 0)
        {
            QAClassifyAnswerResultGroup *group = [[QAClassifyAnswerResultGroup alloc]init];
            group.name = myAnswer.name;
            group.optionInfoArray = array;
            group.headerSize = [QAClassifyAnswerGroupHeaderView sizeForGroupName:group.name optionsCount:group.optionInfoArray.count];
            [self.groupArray addObject:group];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = NO"];
    NSArray *array = [allOptionInfoArray filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        QAClassifyAnswerResultGroup *group = [[QAClassifyAnswerResultGroup alloc]init];
        group.name = @"未归类";
        group.optionInfoArray = array;
        group.headerSize = [QAClassifyAnswerGroupHeaderView sizeForGroupName:group.name optionsCount:group.optionInfoArray.count];
        [self.groupArray addObject:group];
    }
    
    QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:allOptionInfoArray.firstObject.option];
    [self.collectionView registerClass:[cell class] forCellWithReuseIdentifier:@"OptionCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.groupArray[section].optionInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAClassifyOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionCell" forIndexPath:indexPath];
    QAClassifyAnswerResultGroup *group = self.groupArray[indexPath.section];
    QAClassifyOptionInfo *info = group.optionInfoArray[indexPath.row];
    WEAK_SELF
    [cell setSizeChangedBlock:^(CGSize size){
        STRONG_SELF
        if (!CGSizeEqualToSize(size, info.size)){
            info.size = size;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];
    cell.optionString = info.option;
    cell.isCorrect = info.isCorrect;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        QAClassifyAnswerGroupHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAClassifyAnswerGroupHeaderView" forIndexPath:indexPath];
        QAClassifyAnswerResultGroup *group = self.groupArray[indexPath.section];
        [headerView updateWithGroupName:group.name optionsCount:group.optionInfoArray.count];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAClassifyAnswerResultGroup *group = self.groupArray[indexPath.section];
    QAClassifyOptionInfo *info = group.optionInfoArray[indexPath.row];
    return info.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    QAClassifyAnswerResultGroup *group = self.groupArray[section];
    return group.headerSize;
}

@end

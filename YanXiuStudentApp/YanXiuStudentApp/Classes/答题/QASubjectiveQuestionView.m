//
//  QASubjectiveQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionView.h"
#import "YXQAQuestionCell2.h"
#import "YXAddPhotoTableViewCell.h"
#import "QAQuestionUtil.h"
#import "QASubjectiveQuestionCell.h"
@interface QASubjectiveQuestionView ()
@property (nonatomic, strong) YXAddPhotoTableViewCell *addPhotoCell;
@end
@implementation QASubjectiveQuestionView

- (void)setData:(QAQuestion *)data
{
    [super setData:data];
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QASubjectiveQuestionCell class] forCellReuseIdentifier:@"QASubjectiveQuestionCell"];
    [self.tableView registerClass:[YXAddPhotoTableViewCell class] forCellReuseIdentifier:@"YXAddPhotoTableViewCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:NO])];
    [heightArray addObject:@([self getSubjectiveQuestionCellHeight])];
    return heightArray;
}
- (CGFloat)getSubjectiveQuestionCellHeight {
    YXAddPhotoTableViewCell * cell = [[YXAddPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell reloadViewWithArray:self.data.myAnswers addEnable:YES];
    return [cell height];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QASubjectiveQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectiveQuestionCell"];
        cell.delegate = self;
        cell.item = self.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (self.addPhotoCell) {
        self.addPhotoCell.indexPath = indexPath;
        return self.addPhotoCell;
    }else {
        YXAddPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXAddPhotoTableViewCell"];
        [cell reloadViewWithArray:self.data.myAnswers addEnable:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        WEAK_SELF
        cell.photosChangedBlock = ^(NSArray *photos){
            STRONG_SELF
            self.data.myAnswers = [NSMutableArray arrayWithArray:photos];
        };
        self.addPhotoCell = cell;
        self.addPhotoCell.indexPath = indexPath;
        return cell;
    }
}
#pragma mark - YXQASubjectiveAddPhotoDelegate
- (void)photoViewHeightChanged:(CGFloat)height {
    CGFloat cellHeight = [self.cellHeightArray[1] floatValue];
    CGFloat newCellHeight = ceilf(height);
    if (cellHeight != newCellHeight) {
        [self.cellHeightArray replaceObjectAtIndex:1 withObject:@(newCellHeight)];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    }
}
- (void)addPhotoWithViewModel:(YXAlbumViewModel *)viewModel {
    if (self.photoDelegate && [self.photoDelegate respondsToSelector:@selector(addPhotoWithViewModel:)]) {
        [self.photoDelegate addPhotoWithViewModel:viewModel];
    }
}
- (void)photoClickedWithModel:(YXAlbumViewModel *)viewModel index:(NSInteger)index canDelete:(BOOL)canDelete {
    if (self.photoDelegate && [self.photoDelegate respondsToSelector:@selector(photoClickedWithModel:index:canDelete:)]) {
        [self.photoDelegate photoClickedWithModel:viewModel index:index canDelete:canDelete];
    }
}
@end

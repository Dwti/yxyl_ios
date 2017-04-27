//
//  QASubjectiveQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionAnalysisView.h"
#import "YXQAQuestionCell2.h"
#import "YXAddPhotoTableViewCell.h"
#import "YXCommentCell2.h"
#import "QASubjectiveQuestionCell.h"
#import "AudioCommentCell.h"

@interface QASubjectiveQuestionAnalysisView ()<YXQASubjectiveAddPhotoDelegate>
@property (nonatomic, strong) YXAddPhotoTableViewCell *addPhotoCell;
@end

@implementation QASubjectiveQuestionAnalysisView

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
    [cell reloadViewWithArray:self.data.myAnswers addEnable:NO];
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
    
    if (indexPath.row == 1) { 
        if (self.addPhotoCell) {
            return self.addPhotoCell;
        } else {
            YXAddPhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YXAddPhotoTableViewCell"];
            [cell reloadViewWithArray:self.data.myAnswers addEnable:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            self.addPhotoCell = cell;
            return cell;
        }
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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

- (void)leaveForeground {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeaveForegroundNotification" object:nil];
}

@end

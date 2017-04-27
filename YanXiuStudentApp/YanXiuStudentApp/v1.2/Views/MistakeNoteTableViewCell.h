//
//  MistakeNoteTableViewCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/8/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"
#import "EditNoteViewController.h"
#import "QAQuestion.h"
#import "YXAlbumViewModel.h"
#import "YXQASubjectiveAddPhotoDelegate.h"


@interface MistakeNoteTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isEditable;    // textView is editable
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) QAQuestion *questionItem;
@property (nonatomic, copy) void (^editButtonTapped) (void);
@property (nonatomic, copy) void (^textDidChange) (NSString *text);
@property (nonatomic, copy) void (^photosChangedBlock) (NSArray *photos);
@property (nonatomic, weak) id<YXQASubjectiveAddPhotoDelegate>delegate;

- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable;
+ (CGFloat)heightForNoteWithQuestion:(QAQuestion *)item isEditable:(BOOL)isEditable;

@end

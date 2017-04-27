//
//  YXQASubjectiveView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSlideView.h"
#import "YXQASubjectiveAddPhotoDelegate.h"
#import "YXQAAddPhotoCell_Pad.h"

@interface YXQASubjectiveView_Pad : YXSlideViewItemViewBase<UITableViewDataSource, UITableViewDelegate, YXHtmlCellHeightDelegate,YXQASubjectiveAddPhotoDelegate>{
    NSMutableArray *_heightArray;
    YXQAAddPhotoCell_Pad *_addPhotoCell;
}
@property (nonatomic, assign) BOOL bShowTitleState;
@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<YXQASubjectiveAddPhotoDelegate> delegate;

- (CGFloat)photoCellheight;

- (void)_setupUI;
@end

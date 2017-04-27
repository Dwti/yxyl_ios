//
//  YXQAYesNoView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAutoGoNextDelegate.h"
#import "YXQAYesNoChooseCell_Pad.h"
#import "YXSlideView.h"

@interface YXQAYesNoView_Pad : YXSlideViewItemViewBase<UITableViewDataSource, UITableViewDelegate, YXHtmlCellHeightDelegate>{
    NSMutableArray *_heightArray;
}
@property (nonatomic, assign) BOOL bShowTitleState;
@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) id<YXAutoGoNextDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXQAYesNoChooseCell_Pad *chooseView;

- (void)_setupUI;

@end

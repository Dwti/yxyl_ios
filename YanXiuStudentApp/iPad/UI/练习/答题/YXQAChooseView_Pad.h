//
//  YXQAChooseView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSlideView.h"

@interface YXQAChooseView_Pad : YXSlideViewItemViewBase<UITableViewDataSource, UITableViewDelegate, YXHtmlCellHeightDelegate> {
    NSMutableArray *_myAnswerArray;
    NSMutableArray *_heightArray;
}

@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL bShowTitleState;

- (void)_setupUI;

@end

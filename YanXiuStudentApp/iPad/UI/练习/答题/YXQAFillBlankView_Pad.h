//
//  YXQAFillBlankView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSlideView.h"

@interface YXQAFillBlankView_Pad : YXSlideViewItemViewBase<UITableViewDataSource, UITableViewDelegate,YXHtmlCellHeightDelegate>{
    NSMutableArray *_heightArray;
    NSMutableArray *_textFieldArray;
}

@property (nonatomic, assign) BOOL bShowTitleState;
@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UITableView *tableView;

- (void)_setupUI;
- (void)hideKeyboard;

@end

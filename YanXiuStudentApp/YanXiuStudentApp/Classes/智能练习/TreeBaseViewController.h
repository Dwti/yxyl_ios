//
//  TreeBaseViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "TreeDataFetcher.h"
#import "YXTipsView.h"
#import <RATreeView/RATreeView.h>

@interface TreeBaseViewController : BaseViewController<RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic, strong) RATreeView *treeView;
@property (nonatomic, strong) TreeDataFetcher *dataFetcher;
@property (nonatomic, strong) YXTipsView *emptyView;
- (void)fetchTreeData;
@end

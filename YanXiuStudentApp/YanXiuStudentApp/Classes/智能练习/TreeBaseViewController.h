//
//  TreeBaseViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "TreeDataFetcher.h"
#import <RATreeView/RATreeView.h>
#import "EmptyView.h"

@interface TreeBaseViewController : BaseViewController<RATreeViewDataSource, RATreeViewDelegate>
@property (nonatomic, strong) RATreeView *treeView;
@property (nonatomic, strong) TreeDataFetcher *dataFetcher;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) NSArray *treeNodes;
- (void)fetchTreeData;
@end

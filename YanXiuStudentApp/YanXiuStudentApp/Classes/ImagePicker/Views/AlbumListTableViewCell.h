//
//  AlbumListTableViewCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/4/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAssetUtils.h"

@interface AlbumListModel: NSObject
@property (nonatomic, strong) AssetGroupInfo *assetInfo;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface AlbumListTableViewCell : UITableViewCell
@property (nonatomic, strong) AlbumListModel *model;
@end

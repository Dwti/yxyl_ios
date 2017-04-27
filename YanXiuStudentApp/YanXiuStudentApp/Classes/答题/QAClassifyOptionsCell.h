//
//  QAClassifyOptionsCell.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsView.h"

@interface QAClassifyOptionsCell : UITableViewCell
<YXHtmlCellHeightDelegate>

@property (nonatomic, weak) id <YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) OptionsView *optionsView;
@property (nonatomic, strong) NSMutableArray *datas;
+ (CGFloat)heightForItem:(NSMutableArray *)datas;

@end

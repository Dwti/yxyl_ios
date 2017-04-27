//
//  YXUnfinishedHeaderCell.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/22/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXUnfinishedHeaderCell : UITableViewCell
@property (nonatomic, assign) NSInteger unfinishedCount;
@property (nonatomic, copy) void (^clickBlock)();
@end

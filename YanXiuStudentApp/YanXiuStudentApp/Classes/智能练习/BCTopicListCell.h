//
//  BCTopicListCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BCTopicPaper;

@interface BCTopicListCell : UITableViewCell
@property (nonatomic, strong) BCTopicPaper *topicPaper;
@property (nonatomic, assign) BOOL shouldShowLine;
@end

//
//  YXTabBarController.h
//  CustomTab
//
//  Created by niuzhaowang on 15/11/30.
//  Copyright © 2015年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTabBarController : UITabBarController
@property (nonatomic, strong) NSArray *tabButtons;

@property (nonatomic, weak) NSString *practiseNumber;
@property (nonatomic, weak) NSString *assignmentNumber;
@property (nonatomic, weak) NSString *myNumber;

@end

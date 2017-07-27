//
//  BaseViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PrefixHeader.pch"
#import "YXNavigationController.h"

@interface BaseViewController : UIViewController
@property (nonatomic, assign) NavigationBarTheme naviTheme;

- (void)backAction;

@end

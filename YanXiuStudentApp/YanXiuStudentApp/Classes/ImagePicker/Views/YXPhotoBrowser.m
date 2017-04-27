//
//  YXPhotoBrowser.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXPhotoBrowser.h"

@interface YXPhotoBrowser ()
@property(nonatomic, assign) BOOL deleteHidden;
@end

@implementation YXPhotoBrowser

- (void)reloadData {
    [super reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self yx_setupLeftBackBarButtonItem];
    if (!self.deleteHidden) {
        [self setupRightBarButton];
    }
}

- (void)hiddenRightBarButtonItem:(BOOL)hidden {
    self.deleteHidden = hidden;
    if (hidden) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        [self setupRightBarButton];
    }
}
- (void)deleteButton:(UIBarButtonItem *)item {
    if (self.deleteHandle) {
        self.deleteHandle();
    }
}

- (void)setupRightBarButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"删除按钮-按下"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItems = [BaseViewController barButtonItemsWithButton:button];
    
    [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
}

@end

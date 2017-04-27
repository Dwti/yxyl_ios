//
//  YXPhotoBrowser_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPhotoBrowser_Pad.h"

@interface YXPhotoBrowser_Pad ()
@property(nonatomic, assign) BOOL deleteHidden;
@end

@implementation YXPhotoBrowser_Pad

- (void)reloadData
{
    [super reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self setupLeftBack];
    if (!self.deleteHidden) {
        [self setupRightBarButton];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)hiddenRightBarButtonItem:(BOOL)hidden
{
    self.deleteHidden = hidden;
    if (hidden) {
        self.navigationItem.rightBarButtonItems = nil;
    } else {
        [self setupRightBarButton];
    }
}
- (void)deleteButton:(UIBarButtonItem *)item
{
    if (self.deleteHandle) {
        self.deleteHandle();
    }
}

- (void)setupLeftBack{
    [self setupLeftWithImageNamed:@"返回icon" highlightImageNamed:@"返回icon-按下"];
}

- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width+20, normalImage.size.height+20)];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(naviLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems = @[[self negativeBarButtonItem],leftItem];
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupRightBarButton {
    UIImage *normalImage = [UIImage imageNamed:@"删除按钮"];
    UIImage *highlightImage = [UIImage imageNamed:@"删除按钮-按下"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width+20, normalImage.size.height+20)];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

- (UIBarButtonItem *)negativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    return negativeSpacer;
}
@end

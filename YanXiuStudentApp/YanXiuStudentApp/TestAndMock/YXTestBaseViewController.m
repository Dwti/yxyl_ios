//
//  YXTestBaseViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "YXTestBaseViewController.h"

@implementation YXTestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.titleLabel.font = [UIFont systemFontOfSize:10];
//    [btn setTitle:@"联系人" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"t"] forState:UIControlStateNormal];
//    [btn updateWithDefaultHighlightColor];
//    
//    [BaseViewController update_v_image_title_forButton:btn
//                                             withWidth:100
//                                             topMargin:0
//                               gapBetweenTitleAndImage:5
//                                          bottomMargin:0];
//    
//    //    [BaseViewController update_h_image_title_forButton:btn
//    //                                            withHeight:44
//    //                                            leftMargin:10
//    //                               gapBetweenTitleAndImage:2
//    //                                           rightMargin:10];
//    [self.view addSubview:btn];
//    btn.center = self.view.center;
//    
//    btn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    
//    YXListSingleChooseView *v = [[YXListSingleChooseView alloc] init];
//    v.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:v];
//    [v mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
//    v.nameArray = @[@"a", @"b", @"c"];
//    v.curIndex = 1;
    [self setupRotation];
}

- (void)setupRotation {
    UIView *containerView = [[UIView alloc] init];
    containerView.clipsToBounds = YES;
    containerView.backgroundColor = [UIColor grayColor];
    containerView.frame = CGRectMake(0, 100, 300, 72);
    [self.view addSubview:containerView];
    
    UIView *sqrView = [[UIView alloc] init];
    //[self setAnchorPoint:CGPointMake(1, 1) forView:sqrView];
    sqrView.backgroundColor = [UIColor redColor];
    [containerView addSubview:sqrView];
    
    CGFloat w = ceil(sqrt(40*40*2));
    sqrView.frame = CGRectMake(0, 0, w, w);
    sqrView.layer.anchorPoint = CGPointMake(1, 1);
    sqrView.layer.position = CGPointMake(300, 40);
    sqrView.transform = CGAffineTransformMakeRotation(M_PI_4);
//    [sqrView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-36);
//        make.size.mas_equalTo(CGSizeMake(w, w));
//    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"未完成";
    label.textColor     = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:10];
    label.frame = CGRectMake(0, w - 16, w, 16);
    [sqrView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.centerX.mas_equalTo(0);
//    }];
    
    
    
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}
@end

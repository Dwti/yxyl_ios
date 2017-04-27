//
//  QASlideView.h
//  SlideDemo
//
//  Created by niuzhaowang on 2016/9/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASlideItemBaseView.h"

@class QASlideView;

@protocol QASlideViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView;
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index;
@end

@protocol QASlideViewDelegate <NSObject>
@optional
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)slideViewDidReachMostRight:(QASlideView *)slideView;
@end


@interface QASlideView : UIView
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isActive; // default is YES
@property (nonatomic, weak) id<QASlideViewDataSource> dataSource;
@property (nonatomic, weak) id<QASlideViewDelegate> delegate;

- (void)scrollToItemIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;
- (QASlideItemBaseView *)itemViewAtIndex:(NSInteger)index; // maybe nil if not loaded or has been recycled.

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

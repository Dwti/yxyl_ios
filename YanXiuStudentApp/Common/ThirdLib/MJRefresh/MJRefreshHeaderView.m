//
//  MJRefreshHeaderView.m
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshConst.h"
#import "MJRefreshHeaderView.h"
#import "EERefreshHeaderView.h"

@interface MJRefreshHeaderView()
// 最后的更新时间
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, weak) EERefreshHeaderView *eeHeaderView;
@property (nonatomic, assign) BOOL needEndRefreshingWhenBubbleFinished;
@end

@implementation MJRefreshHeaderView

+ (instancetype)header
{
    return [[MJRefreshHeaderView alloc] init];
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    if (self.eeHeaderView.animationFinished) {
        [super endRefreshing];
    }else {
        self.needEndRefreshingWhenBubbleFinished = YES;
    }
}

#pragma mark - UIScrollView相关
#pragma mark 重写设置ScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    
    // 1.设置边框
    self.frame = CGRectMake(0, - MJRefreshViewHeight, scrollView.frame.size.width, MJRefreshViewHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // 2.加载时间
    self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:MJRefreshHeaderTimeKey];
    
    EERefreshHeaderView *headerView = [[EERefreshHeaderView alloc]initWithMJHeaderView:self];
    WEAK_SELF
    [headerView setEndBubbleBlock:^{
        STRONG_SELF
        if (self.needEndRefreshingWhenBubbleFinished) {
            [super endRefreshing];
            self.needEndRefreshingWhenBubbleFinished = NO;
        }
    }];
    [scrollView addSubview:headerView];
    self.eeHeaderView = headerView;
//    [scrollView.panGestureRecognizer addTarget:self action:@selector(panAction:)];
}
//- (void)panAction:(UIPanGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
//        if (_state == MJRefreshStatePulling) {
//            self.eeHeaderView.refreshing = YES;
//        }
//        if (_scrollView.layer.presentationLayer.bounds.origin.y!=_scrollView.bounds.origin.y) {
//            NSLog(@"");
//        }
//        if (ABS(_scrollView.layer.presentationLayer.bounds.origin.y)>=MJRefreshViewHeight+[self.eeHeaderView bottomHeight]) {
//            self.eeHeaderView.refreshing = YES;
//        }
//    }
//    
//}

#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:MJRefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateTime];
    
    // 3.显示日期
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.eeHeaderView updateWithOffset:_scrollView.contentOffset.y];
    
    if (![MJRefreshContentOffset isEqualToString:keyPath]) return;
    
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == MJRefreshStateRefreshing) return;
    
    // scrollView所滚动的Y值 * 控件的类型（头部控件是-1，尾部控件是1）
    CGFloat offsetY = _scrollView.contentOffset.y * self.viewType;
    CGFloat validY = self.validY;
    if (offsetY <= validY) return;
    
    if (_scrollView.isDragging) {
        CGFloat validOffsetY = validY + MJRefreshViewHeight + [self.eeHeaderView bottomHeight];
//        CGFloat r = offsetY / validOffsetY;
//        self.imageView.transform = CGAffineTransformMakeRotation(2*M_PI*r);
//        if (_state == MJRefreshStateNormal) {
//            CGFloat f = (MIN(offsetY, validOffsetY) / validOffsetY);
//            self.imageView.transform = CGAffineTransformMakeScale(f, f);
//            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, 2*M_PI*r);
//            self.imageView.alpha = f;
//            [self bringSubviewToFront:self.imageView];
//        }
        
        
        if (_state == MJRefreshStatePulling && offsetY <= validOffsetY) {
            // 转为普通状态
            [self setState:MJRefreshStateNormal];
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [self.delegate refreshView:self stateChange:MJRefreshStateNormal];
            }
            
            // 回调
            if (self.refreshStateChangeBlock) {
                self.refreshStateChangeBlock(self, MJRefreshStateNormal);
            }
        } else if (_state == MJRefreshStateNormal && offsetY > validOffsetY) {
            // 转为即将刷新状态
            [self setState:MJRefreshStatePulling];
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [self.delegate refreshView:self stateChange:MJRefreshStatePulling];
            }
            
            // 回调
            if (self.refreshStateChangeBlock) {
                self.refreshStateChangeBlock(self, MJRefreshStatePulling);
            }
        }
    } else { // 即将刷新 && 手松开
        if (_state == MJRefreshStatePulling) {
            // 开始刷新
            [self setState:MJRefreshStateRefreshing];
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [self.delegate refreshView:self stateChange:MJRefreshStateRefreshing];
            }
            
            // 回调
            if (self.refreshStateChangeBlock) {
                self.refreshStateChangeBlock(self, MJRefreshStateRefreshing);
            }
        }
    }
}

#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{
    // 1.一样的就直接返回
    if (_state == state) return;
    
    // 2.保存旧状态
    MJRefreshState oldState = _state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态执行不同的操作
	switch (state) {
		case MJRefreshStatePulling: // 松开可立即刷新
        {
            // 设置文字
            _statusLabel.text = MJRefreshHeaderReleaseToRefresh;
            // 执行动画
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case MJRefreshStateNormal: // 下拉可以刷新
        {
            // 设置文字
			_statusLabel.text = MJRefreshHeaderPullToRefresh;
            // 执行动画
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top;
                _scrollView.contentInset = inset;
            }];
            
            // 刷新完毕
            if (MJRefreshStateRefreshing == oldState) {
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
            }
            self.eeHeaderView.refreshing = NO;
            [self.eeHeaderView updateWithOffset:_scrollView.contentOffset.y];
			break;
        }
            
		case MJRefreshStateRefreshing: // 正在刷新中
        {
            // 设置文字
            _statusLabel.text = MJRefreshHeaderRefreshing;
            // 执行动画
            [UIView animateWithDuration:MJRefreshAnimationDuration animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                // 1.增加65的滚动区域
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _scrollViewInitInset.top + MJRefreshViewHeight;
                _scrollView.contentInset = inset;
                // 2.设置滚动位置
                _scrollView.contentOffset = CGPointMake(0, - inset.top);
            }];
            self.eeHeaderView.refreshing = YES;
            [self.eeHeaderView updateWithOffset:_scrollView.contentOffset.y];
			break;
        }
            
        default:
            break;
	}
}

#pragma mark - 在父类中用得上
// 合理的Y值(刚好看到下拉刷新控件时的contentOffset.y，取相反数)
- (CGFloat)validY
{
    return _scrollViewInitInset.top;
}

// view的类型
- (int)viewType
{
    return MJRefreshViewTypeHeader;
}
@end

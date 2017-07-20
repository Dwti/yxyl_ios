//
//  QASlideView.m
//  SlideDemo
//
//  Created by niuzhaowang on 2016/9/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "QASlideView.h"

static const NSInteger kItemViewTagBase = 1234;

@interface QASlideView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *itemContainerView;
@property (nonatomic, assign) BOOL layoutComplete;
@property (nonatomic, strong) NSMutableArray *remainedItemViewArray;
@property (nonatomic, assign) NSInteger lastCurrentIndex;
@property (nonatomic, assign) CGPoint offsetBeforeDecelerate;
@end

@implementation QASlideView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isActive = YES;
        self.currentIndex = 0;
        self.remainedItemViewArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    [self addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.itemContainerView = [[UIView alloc]init];
    [self.mainScrollView addSubview:self.itemContainerView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    self.panGesture = pan;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.layoutComplete) {
        return;
    }
    [self loadItemViewsForFirstLayout];
    self.layoutComplete = YES;
}

- (void)loadItemViewsForFirstLayout{
    NSInteger itemCount = [self.dataSource numberOfItemsInSlideView:self];
    if (itemCount == 0) {
        return;
    }
    
    [self layoutItemContainerView];
    [self loadAndLayoutItemViews];
    [self scrollToItemIndex:self.currentIndex animated:NO];
}

- (void)layoutItemContainerView{
    NSInteger itemCount = [self.dataSource numberOfItemsInSlideView:self];
    [self.itemContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(self.mainScrollView);
        make.width.mas_equalTo(self.mainScrollView).multipliedBy(itemCount);
    }];
}

- (void)loadAndLayoutItemViews{
    NSInteger preIndex = [self preItemIndex];
    NSInteger nextIndex = [self nextItemIndex];
    for (NSInteger i=preIndex; i<=nextIndex; i++) {
        if ([self isItemExistingWithIndex:i]) {
            continue;
        }
        QASlideItemBaseView *itemView = [self.dataSource slideView:self itemViewAtIndex:i];
        itemView.tag = kItemViewTagBase+i;
        [self.itemContainerView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.mainScrollView.width*i);
            make.width.mas_equalTo(self.mainScrollView.width);
        }];
        
        [self setupForegroundStatusWithItemView:itemView];
    }
}

- (NSInteger)preItemIndex{
    return MAX(self.currentIndex-1, 0);
}

- (NSInteger)nextItemIndex{
    NSInteger itemCount = [self.dataSource numberOfItemsInSlideView:self];
    return MIN(self.currentIndex+1, itemCount-1);
}

- (BOOL)isItemExistingWithIndex:(NSInteger)index{
    for (QASlideItemBaseView *itemView in self.remainedItemViewArray) {
        NSInteger itemIndex = itemView.tag-kItemViewTagBase;
        if (itemIndex == index) {
            return YES;
        }
    }
    return NO;
}

- (void)setupForegroundStatusWithItemView:(QASlideItemBaseView *)itemView{
    if (!self.isActive) {
        itemView.isForeground = NO;
        return;
    }
    NSInteger itemIndex = itemView.tag - kItemViewTagBase;
    if (self.currentIndex == itemIndex) {
        itemView.isForeground = YES;
    }else{
        itemView.isForeground = NO;
    }
}

- (void)scrollToItemIndex:(NSInteger)index animated:(BOOL)animated{
    NSInteger total = [self.dataSource numberOfItemsInSlideView:self];
    CGFloat offsetX = self.mainScrollView.width * MIN(total-1, index);
    [self.mainScrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    if (!animated) {
        [self handleCurrentItemChange];
    }
}

- (void)handleCurrentItemChange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideView:didSlideFromIndex:toIndex:)]) {
        [self.delegate slideView:self didSlideFromIndex:self.lastCurrentIndex toIndex:self.currentIndex];
    }
}

- (void)reloadData{
    for (QASlideItemBaseView *itemView in self.itemContainerView.subviews) {
        itemView.isForeground = NO;
        [itemView removeFromSuperview];
    }
    [self.remainedItemViewArray removeAllObjects];
    
    [self layoutItemContainerView];
    [self loadAndLayoutItemViews];
    [self scrollToItemIndex:self.currentIndex animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.mainScrollView.contentOffset.x;
    CGFloat minX = (self.currentIndex-1) * self.mainScrollView.width;
    CGFloat maxX = (self.currentIndex+1) * self.mainScrollView.width;
    if (offsetX>minX && offsetX<maxX) {
        return;
    }
    NSInteger index = offsetX/self.mainScrollView.width;
    self.currentIndex = index;
    [self updateRemainedItemViews];
    [self loadAndLayoutItemViews];
}

- (void)updateRemainedItemViews{
    NSInteger preIndex = [self preItemIndex];
    NSInteger nextIndex = [self nextItemIndex];
    [self.remainedItemViewArray removeAllObjects];
    for (QASlideItemBaseView *itemView in self.itemContainerView.subviews) {
        NSInteger index = itemView.tag-kItemViewTagBase;
        if (index>=preIndex && index<=nextIndex) {
            [self.remainedItemViewArray addObject:itemView];
        }else{
            [itemView removeFromSuperview];
        }
        
        [self setupForegroundStatusWithItemView:itemView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        self.offsetBeforeDecelerate = scrollView.contentOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //此处需要特殊处理一下，在scrollview不能滑动时，仍然能相应手势执行这个回调，导致逻辑异常
    if (CGPointEqualToPoint(scrollView.contentOffset, self.offsetBeforeDecelerate)) {
        return;
    }
    [self handleCurrentItemChange];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self handleCurrentItemChange];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]] && [otherGestureRecognizer.view.superview isKindOfClass:[self class]]) {
        return YES;
    }
    if ([otherGestureRecognizer.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}
#pragma mark - Gesture Action
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint velocity = [gesture velocityInView:gesture.view];
    if (![self isSlidingToRightWithVelocityPoint:velocity]) {
        return;
    }
    if ([self hasScrollViewReachedMostRight]) {
        if ([self.delegate respondsToSelector:@selector(slideViewDidReachMostRight:)]) {
            [self.delegate slideViewDidReachMostRight:self];
        }
    }
}

- (BOOL)isSlidingToRightWithVelocityPoint:(CGPoint)point{
    return (ABS(point.x)/ABS(point.y)>2 && point.x<0);
}

- (BOOL)hasScrollViewReachedMostRight{
    return self.mainScrollView.contentOffset.x >= self.mainScrollView.contentSize.width-self.mainScrollView.bounds.size.width;
}

#pragma mark - Setters
- (void)setIsActive:(BOOL)isActive{
    if (_isActive == isActive) {
        return;
    }
    _isActive = isActive;
    QASlideItemBaseView *currentItemView = [self itemViewAtIndex:self.currentIndex];
    [self setupForegroundStatusWithItemView:currentItemView];
}

- (QASlideItemBaseView *)itemViewAtIndex:(NSInteger)index{
    QASlideItemBaseView *itemView = nil;
    for (QASlideItemBaseView *view in self.itemContainerView.subviews) {
        if (view.tag == index+kItemViewTagBase) {
            itemView = view;
            break;
        }
    }
    return itemView;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    self.lastCurrentIndex = _currentIndex;
    _currentIndex = currentIndex;
}

@end

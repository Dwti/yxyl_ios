//
//  QAComlexQuestionAnswerBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAComlexQuestionAnswerBaseView.h"
#import "YXYueCell2.h"

@interface QAComlexQuestionAnswerBaseView()

@property (nonatomic, strong) UILabel *progressLabel;

@end


@implementation QAComlexQuestionAnswerBaseView
- (CGFloat)minTopHeight {
    return 50;
}
- (CGFloat)maxTopHeight {
    return SCREEN_HEIGHT-55-43-20-45;
}
#pragma mark - override
- (void)enterForeground {
    [super enterForeground];
    self.slideView.isActive = YES;
}

- (void)leaveForeground {
    [super leaveForeground];
    self.slideView.isActive = NO;
}

- (void)setupUI {
    [super setupUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    // “材料” 部分
    [self setupMaterialView];

    // 滑动条与进度条
    [self setupMoveSliderView];

    // “问答” 部分
    [self setupQAView];
    
    //监听键盘
    [self setupKeyboardObserver];
}

- (void)setupMaterialView {
    self.upContainerView = [[UIView alloc] init];
    self.upContainerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.upContainerView];
    
    UIView<QAComplexTopContainerViewDelegate> *containerView = [self topContainerView];
    [self.upContainerView addSubview:containerView];
    
    CGFloat height = MAX([containerView initialHeight], [self minTopHeight]);
    height = MIN(height, 150);
    [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupMoveSliderView {
    self.middleContainerView = [[UIView alloc] init];
    self.middleContainerView.backgroundColor = [UIColor whiteColor];
    self.middleContainerView.clipsToBounds = YES;
    [self addSubview:self.middleContainerView];
    [self.middleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upContainerView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageWithColor:[UIColor blueColor]];
    imageView.userInteractionEnabled = YES;
    imageView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, -2.5);
    imageView.layer.shadowRadius = 2.5;
    imageView.layer.shadowOpacity = 0.02;
    [self.middleContainerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(69, 20));
    }];
    
    UIView *sepLineView = [[UIView alloc]init];
    sepLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.middleContainerView addSubview:sepLineView];
    [sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.middleContainerView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(sepLineView.mas_bottom).mas_offset(39);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *qLabel = [[UILabel alloc]init];
    qLabel.text = @"问题";
    qLabel.textColor = [UIColor colorWithHexString:@"333333"];
    qLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.middleContainerView addSubview:qLabel];
    [qLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(sepLineView.mas_bottom);
        make.bottom.mas_equalTo(bottomLineView.mas_top);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont fontWithName:YXFontMetro_Regular size:16];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.progressLabel.textAlignment = NSTextAlignmentRight;
    [self.middleContainerView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(qLabel.mas_centerY);
    }];
    
    [self addPanGestureRecognizerFor:imageView];
}

- (void)setupQAView {
    self.downContainerView = [[UIView alloc] init];
    [self addSubview:self.downContainerView];
    [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.middleContainerView.mas_bottom);
    }];
    
    self.slideView = [[QASlideView alloc] init];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.currentIndex = self.nextLevelStartIndex;
    
    [self.downContainerView addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)addPanGestureRecognizerFor:(UIImageView *)imgView {
    UIPanGestureRecognizer *panGestureRecognizer = [UIPanGestureRecognizer new];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [imgView addGestureRecognizer:panGestureRecognizer];

    WEAK_SELF
    [[panGestureRecognizer rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *paramSender) {
        STRONG_SELF
        if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed) {
            CGPoint translation = [paramSender translationInView:self];
            CGFloat height = self.upContainerView.height+translation.y;
            height = MAX(height, [self minTopHeight]);
            height = MIN(height, [self maxTopHeight]);
            [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleView.mas_bottom);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(height);
            }];
            if ((self.upContainerView.height+translation.y) > [self minTopHeight] && self.upContainerView.height+translation.y < [self maxTopHeight]) {
                
            }
            [paramSender setTranslation:CGPointZero inView:paramSender.view];
        }
    }];
}

- (void)setupKeyboardObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        CGRect rect = [self.middleContainerView convertRect:self.middleContainerView.bounds toView:self.window];
        if (rect.origin.y+rect.size.height > keyboardFrame.origin.y) {
            [UIView animateWithDuration:duration.floatValue animations:^{
                [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.titleView.mas_bottom);
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo([self minTopHeight]);
                }];
                [self layoutIfNeeded];
            }];
        }
    }];
}

// subclass need to override this func to add specific UI
- (UIView<QAComplexTopContainerViewDelegate> *)topContainerView {
    return nil;
}

#pragma mark - slide tab datasource delegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return [self.data.childQuestions count];
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionAnswerView];
    view.data = data;
    view.isPaperSubmitted = self.isPaperSubmitted;
    view.isSubQuestionView = YES;
    view.photoDelegate = self.addPhotoHandler;
    view.delegate = self;
    view.answerStateChangeDelegate = self.answerStateChangeDelegate;
    return view;
}

- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    QAQuestion *item = self.data.childQuestions[to];
    if (self.slideDelegate && [self.slideDelegate respondsToSelector:@selector(questionView:didSlideToChildQuestion:)]) {
        [self.slideDelegate questionView:self didSlideToChildQuestion:item];
    }
    
    self.progressLabel.attributedText = [self attrbutedProgress:item];
}

- (void)autoGoNextGoGoGo {

}

- (NSAttributedString *)attrbutedProgress:(QAQuestion *)item {
    NSString *completeString = item.position.indexString;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:completeString];
    NSRange slashRange = [completeString rangeOfString:@"/"];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Light size:16]} range:slashRange];
    
    return attrString;
}

@end

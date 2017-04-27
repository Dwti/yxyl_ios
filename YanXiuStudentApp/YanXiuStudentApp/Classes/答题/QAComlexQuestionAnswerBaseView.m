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

@property (nonatomic, strong) UIView *upContainerView;
@property (nonatomic, strong) UILabel *progressLabel;

@end


@implementation QAComlexQuestionAnswerBaseView

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
}

- (void)setupMaterialView {
    self.upContainerView = [[UIView alloc] init];
    [self addSubview:self.upContainerView];
    [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(148);
    }];
    
    UIView *containerView = [self topContainerView];
    containerView.backgroundColor = [UIColor yellowColor];
    containerView.backgroundColor = [UIColor clearColor];
    [self.upContainerView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupMoveSliderView {
    self.middleContainerView = [[UIView alloc] init];
    [self addSubview:self.middleContainerView];
    [self.middleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upContainerView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"上拉"];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeCenter;
    
    [self.middleContainerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(53);
        make.top.mas_offset(0);
    }];
    
    [self addPanGestureRecognizerFor:imageView];
    
    UIImageView *leftLine = [UIImageView new];
    leftLine.image = [UIImage imageNamed:@"间隔线"];
    [self.middleContainerView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.equalTo(imageView.mas_left).offset(-11);
        make.centerY.equalTo(imageView);
    }];
    
    UIImageView *rightLine = [UIImageView new];
    rightLine.image = [UIImage imageNamed:@"间隔线"];
    [self.middleContainerView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.left.equalTo(imageView.mas_right).offset(11);
        make.centerY.equalTo(imageView);
    }];
    
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:11];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"807c6c"];
    
    [self.middleContainerView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(8);
        make.right.equalTo(self.upContainerView.mas_right).offset(-20);
    }];
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
            if ((self.upContainerView.height+translation.y) > 120 && self.upContainerView.height < self.bounds.size.height-50) {
                [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.titleView.mas_bottom);
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(self.upContainerView.height + translation.y);
                }];
            }
            [paramSender setTranslation:CGPointZero inView:paramSender.view];
        }
    }];
}

// subclass need to override this func to add specific UI
- (UIView *)topContainerView {
    return [[UIView alloc] init];
}

#pragma mark - slide tab datasource delegate
- (NSInteger)numberOfItemsInSlideView:(QASlideView *)slideView {
    return [self.data.childQuestions count];
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithTemplate:data.templateType];
    QAQuestionBaseView *view = [container questionAnswerView];
    view.data = data;
    view.isPaperSubmitted = self.isPaperSubmitted;
    view.isSubQuestionView = YES;
    view.photoDelegate = self.addPhotoHandler;
    view.delegate = self;
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
    if (self.slideView.currentIndex == ([self.data.childQuestions count] - 1)) {
        [self.delegate autoGoNextGoGoGo];
        return;
    }
    [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
}

- (NSAttributedString *)attrbutedProgress:(QAQuestion *)item {
    
    NSString *completeString = item.position.indexString;
    NSString *indexString = [[completeString componentsSeparatedByString:@"/"] objectAtIndex:0];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:completeString];
    NSRange indexRange = [completeString rangeOfString:indexString];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontMetro_Bold size:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"807c6c"]} range:indexRange];
    
    return attrString;
}

@end

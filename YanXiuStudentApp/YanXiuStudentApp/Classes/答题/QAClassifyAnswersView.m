//
//  QAClassifyAnswersView.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyAnswersView.h"
#import "YXClassesView.h"
@interface QAClassifyAnswersView()

@property (nonatomic, strong) OptionsView *answersContentView;
@property (nonatomic, strong) UIImageView *answersImageView;

@end

@implementation QAClassifyAnswersView

#pragma mark- Get
- (NSMutableArray *)datas{
    return self.answersContentView.datas;
}

- (NSString *)title{
    return self.answersContentView.titleLabel.text;
}

- (DeleteBlock)deleteBlock{
    return self.answersContentView.deleteBlock;
}

#pragma makr- Set
- (void)setType:(OptionsDataType)type{
    _type = type;
    [self.answersContentView removeFromSuperview];
    self.answersContentView = [[OptionsView alloc] initWithDataType:_type];
    self.answersContentView.selected = YES;
    [self.answersImageView addSubview:self.answersContentView];
    [self.answersContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 17;
        make.bottom.offset = -24;
        make.left.right.offset = 0;
    }];
}

- (void)setTitle:(NSString *)title{
    self.answersContentView.titleLabel.text = title;
}

- (void)setDatas:(NSMutableArray *)datas{
    self.answersContentView.datas = datas;
}

- (void)setDeleteBlock:(DeleteBlock)deleteBlock{
    self.answersContentView.deleteBlock = deleteBlock;
}

- (void)setIsAnalysis:(BOOL)isAnalysis {
    _isAnalysis = isAnalysis;
    self.answersContentView.isAnalysis = isAnalysis;
}

#pragma mark- Function
- (void)show{
    UIWindow *window = [([UIApplication sharedApplication].delegate) window];
    [window addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    CGFloat height = self.answersContentView.estimatedHeight + 24 + 17;
    CGFloat maxHeight = SCREEN_HEIGHT - 193 - 99;
    if (height > maxHeight) {
        self.answersContentView.contentSize = CGSizeMake(0, self.answersContentView.estimatedHeight);
        height = maxHeight;
    }else{
        self.answersContentView.contentSize = CGSizeZero;
    }
    [self.answersImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.offset = SCREEN_WIDTH - 70;
        make.centerX.mas_equalTo(0);
        make.top.offset = 193;
        make.height.offset = height;
    }];
}

- (void)hide{
    [self removeFromSuperview];
}

#pragma mark-
- (void)setupUI{
    self.answersImageView = [UIImageView new];
    self.answersImageView.image = [UIImage yx_resizableImageNamed:@"通用背景"];
    self.answersImageView.userInteractionEnabled = YES;
    [self addSubview:self.answersImageView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor colorWithGray:0] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        [self setupUI];
    }
    return self;
}

@end

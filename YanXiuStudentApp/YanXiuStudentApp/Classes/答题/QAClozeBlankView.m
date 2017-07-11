//
//  QAClozeBlankView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClozeBlankView.h"

@interface QAClozeBlankView()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation QAClozeBlankView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    UIButton *bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    [bgButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-2, self.width, 2)];
    line.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    line.layer.cornerRadius = 1;
    line.clipsToBounds = YES;
    [self addSubview:line];
    self.lineView = line;
    
    self.indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-2-1-16, 16, 16)];
    self.indexLabel.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.indexLabel.textColor = [UIColor whiteColor];
    self.indexLabel.font = [UIFont fontWithName:YXFontArialNarrow_Bold size:15];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.layer.cornerRadius = self.indexLabel.width/2;
    self.indexLabel.clipsToBounds = YES;
    [self addSubview:self.indexLabel];
    
    CGFloat x = self.indexLabel.x+self.indexLabel.width+5;
    CGFloat width = self.width-x;
    self.answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, self.indexLabel.y, width, self.indexLabel.height)];
    self.answerLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    self.answerLabel.font = [UIFont fontWithName:YXFontArialNarrow_Bold size:15];
    [self addSubview:self.answerLabel];
}

- (void)btnAction {
    BLOCK_EXEC(self.clickAction);
}

- (void)updateWithIndex:(NSInteger)index answer:(NSString *)answer {
    self.indexLabel.text = [NSString stringWithFormat:@"%@",@(index)];
    self.answerLabel.text = answer;
    if (isEmpty(answer)) {
        self.indexLabel.frame = CGRectMake((self.width-self.indexLabel.width)/2, self.indexLabel.y, self.indexLabel.width, self.indexLabel.height);
    }else {
        self.indexLabel.frame = CGRectMake(0, self.indexLabel.y, self.indexLabel.width, self.indexLabel.height);
        CGFloat x = self.indexLabel.x+self.indexLabel.width+5;
        CGFloat width = self.width-x;
        self.answerLabel.frame = CGRectMake(x, self.indexLabel.y, width, self.indexLabel.height);
    }
}

- (void)enter {
    [self enterAnimated:YES];
}

- (void)enterAnimated:(BOOL)animated {
    self.answerLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (isEmpty(self.answerLabel.text)) {
        NSTimeInterval duration = animated? 0.2:0;
        [UIView animateWithDuration:duration animations:^{
            self.indexLabel.frame = CGRectMake(0, self.indexLabel.y, self.indexLabel.width, self.indexLabel.height);
        }];
    }
}

- (void)leave {
    self.answerLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
    if (isEmpty(self.answerLabel.text)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.indexLabel.frame = CGRectMake((self.width-self.indexLabel.width)/2, self.indexLabel.y, self.indexLabel.width, self.indexLabel.height);
        }];
    }
}

- (void)updateWithState:(YXQAAnswerState)state current:(BOOL)isCurrent {
    if (isCurrent) {
        [self.answerLabel sizeToFit];
        CGFloat x = (self.width-self.indexLabel.width-self.answerLabel.width-5)/2;
        if (state == YXAnswerStateNotAnswer) {
            x = (self.width-self.indexLabel.width)/2;
        }
        self.indexLabel.frame = CGRectMake(x, self.indexLabel.y, self.indexLabel.width, self.indexLabel.height);
        self.answerLabel.frame = CGRectMake(x+self.answerLabel.x, self.answerLabel.y, self.width-x*2-self.indexLabel.width-5, self.answerLabel.height);
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height+6)];
        bgView.layer.cornerRadius = 6;
        bgView.clipsToBounds = YES;
        [self insertSubview:bgView atIndex:0];
        if (state == YXAnswerStateCorrect) {
            self.indexLabel.backgroundColor = [UIColor whiteColor];
            self.indexLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
            self.answerLabel.textColor = [UIColor whiteColor];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
            bgView.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
        }else {
            self.indexLabel.backgroundColor = [UIColor whiteColor];
            self.indexLabel.textColor = [UIColor colorWithHexString:@"ff7a05"];
            self.answerLabel.textColor = [UIColor whiteColor];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"ff7a05"];
            bgView.backgroundColor = [UIColor colorWithHexString:@"ff7a05"];
        }
    }else {
        if (state == YXAnswerStateCorrect) {
            
        }else {
            self.indexLabel.backgroundColor = [UIColor colorWithHexString:@"ff7a05"];
            self.indexLabel.textColor = [UIColor whiteColor];
            self.answerLabel.textColor = [UIColor colorWithHexString:@"ff7a05"];
            self.lineView.backgroundColor = [UIColor colorWithHexString:@"ff7a05"];
        }
    }
}

@end

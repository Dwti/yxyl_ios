//
//  QASubjectiveFillPlaceholderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveFillPlaceholderView.h"

@interface QASubjectiveFillPlaceholderView ()
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation QASubjectiveFillPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.indexLabel = [[UILabel alloc]init];
    self.indexLabel.textAlignment = NSTextAlignmentCenter;
    self.indexLabel.font = [UIFont fontWithName:@"Times New Roman" size:15];
    [self addSubview:self.indexLabel];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor blackColor];
    [self addSubview:self.line];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.indexLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.line.frame = CGRectMake(0, frame.size.height - 1, frame.size.width, 1);
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"(%@)",@(index+1)];
}

- (void)setIndexHidden:(BOOL)indexHidden {
    _indexHidden = indexHidden;
    self.indexLabel.hidden = indexHidden;
}

@end

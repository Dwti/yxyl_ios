//
//  YXMistakeListWithoutRedoViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 11/04/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXMistakeListWithoutRedoViewController.h"

@interface YXMistakeListWithoutRedoViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation YXMistakeListWithoutRedoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"背景01"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.bgImageView belowSubview:self.tableView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];    
    
    [self yx_setupLeftBackBarButtonItem];
    self.redoButton.hidden = YES;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.title = self.chapter_point_title;
}

- (void)getMistakeRedoQuestionNumber {
    // 这里有个诡异的问题，因为“全部错题”也用了MistakeListViewController，所以如果这里发了消息。那边就不会收到网络反回了
}

@end

//
//  MistakeSheetViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeSheetViewController.h"
#import "MistakeQuestionSheetView.h"

@interface MistakeSheetViewController ()
@property (nonatomic, strong) MistakeQuestionSheetView *sheetView;
@property (nonatomic, copy) SelectedActionBlock buttonActionBlock;
@property (nonatomic, copy) BackActionBlock backBlock;
@end

@implementation MistakeSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    self.title = self.model.paperTitle;
    [self setupObserver];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.sheetView = [[MistakeQuestionSheetView alloc]init];
    self.sheetView.model = self.model;
    [self.view addSubview:self.sheetView];
    [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kQASelectedMiatakeQuestionNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        QAQuestion *item = dic[kQASelectedMistakeQuestionKey];
        [self.navigationController popViewControllerAnimated:YES];
        BLOCK_EXEC(self.buttonActionBlock,item);
    }];
}

- (void)backAction {
    [super backAction];
    BLOCK_EXEC(self.backBlock);
}

- (void)setSelectedActionBlock:(SelectedActionBlock)block {
    self.buttonActionBlock = block;
}

- (void)setBackActionBlock:(BackActionBlock)block {
    self.backBlock = block;
}


@end

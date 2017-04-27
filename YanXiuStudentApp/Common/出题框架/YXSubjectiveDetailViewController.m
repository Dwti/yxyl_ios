//
//  YXSubjectiveDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSubjectiveDetailViewController.h"

@interface YXSubjectiveDetailViewController ()

@end

@implementation YXSubjectiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"问答题配置";
    self.descLabel.text = @"注：测试答题界面请不要添加照片";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    [super setupUI];
    // 答案
    self.answerLabel = [[UILabel alloc]init];
    self.answerLabel.text = @"照片个数(最大为9):";
    [self.containerView addSubview:self.answerLabel];
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.identifierLabel.mas_left);
        make.top.mas_equalTo(self.identifierLabel.mas_bottom).mas_offset(20);
    }];
    UITextField *field = [[UITextField alloc]init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.returnKeyType = UIReturnKeyDone;
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.delegate = self;
    self.answerField = field;
    [self.containerView addSubview:self.answerField];
    [self.answerField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.answerLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.answerLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    // 是否批改
    self.checkLabel = [[UILabel alloc]init];
    self.checkLabel.text = @"是否批改:";
    [self.containerView addSubview:self.checkLabel];
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.answerLabel.mas_left);
        make.top.mas_equalTo(self.answerLabel.mas_bottom).mas_offset(20);
    }];
    self.checkButton = [[UIButton alloc]init];
    [self.checkButton setTitle:@"否" forState:UIControlStateNormal];
    [self.checkButton setTitle:@"是" forState:UIControlStateSelected];
    [self.checkButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.checkButton.layer.cornerRadius = 3;
    self.checkButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.checkButton.layer.borderWidth = 1;
    self.checkButton.clipsToBounds = YES;
    [self.checkButton addTarget:self action:@selector(checkBunAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.checkButton];
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.checkLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    // 评分
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.text = @"评分(最大为5):";
    [self.containerView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkLabel.mas_left);
        make.top.mas_equalTo(self.checkLabel.mas_bottom).mas_offset(20);
    }];
    self.scoreField = [[UITextField alloc]init];
    self.scoreField.borderStyle = UITextBorderStyleRoundedRect;
    self.scoreField.returnKeyType = UIReturnKeyDone;
    self.scoreField.keyboardType = UIKeyboardTypeNumberPad;
    self.scoreField.delegate = self;
    [self.containerView addSubview:self.scoreField];
    [self.scoreField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.scoreLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    // 老师评语
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.text = @"老师评语:";
    [self.containerView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreLabel.mas_left);
        make.top.mas_equalTo(self.scoreLabel.mas_bottom).mas_offset(20);
    }];
    self.commentView = [[UITextView alloc]init];
    self.commentView.layer.cornerRadius = 3;
    self.commentView.layer.borderWidth = 1;
    self.commentView.layer.borderColor = [UIColor blueColor].CGColor;
    self.commentView.clipsToBounds = YES;
    [self.containerView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.commentLabel.mas_right).mas_offset(20);
        make.top.mas_equalTo(self.commentLabel.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(80);
    }];
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    self.answerField.text = [NSString stringWithFormat:@"%@",@(self.question.pad.jsonAnswer.count)];
    self.checkButton.selected = [self.question.pad.status isEqualToString:@"5"];
    self.scoreField.text = self.question.pad.teachercheck.score;
    self.commentView.text = self.question.pad.teachercheck.qcomment;
    
}

- (void)checkBunAction{
    self.checkButton.selected = !self.checkButton.selected;
}

- (void)saveData{
    [super saveData];
    NSInteger photoNum = MIN(self.answerField.text.integerValue, 9);
    NSMutableArray *photoArray = [NSMutableArray array];
    for (int i=0; i<photoNum; i++) {
        [photoArray addObject:@"http://v1.qzone.cc/avatar/201503/21/23/43/550d91b3a64d5763.jpg%21200x200.jpg"];
    }
    self.question.pad.jsonAnswer = photoArray;
    
    if (self.checkButton.selected) {
        self.question.pad.status = @"5";
    }else{
        self.question.pad.status = @"4";
    }
    
    NSInteger score = MIN(self.scoreField.text.integerValue, 5);
    self.question.pad.teachercheck.score = [NSString stringWithFormat:@"%@",@(score)];
    
    self.question.pad.teachercheck.qcomment = self.commentView.text;
}

@end

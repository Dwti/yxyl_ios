//
//  PaperListViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PaperListViewController.h"
#import "YXAnswerQuestionViewController.h"
#import "YXJieXiViewController.h"
#import "YXQAReportViewController.h"
#import "MistakeRedoViewController.h"
#import "QAAnalysisViewController.h"

@interface PaperListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<QAPaperModel *> *paperArray;
@end

@implementation PaperListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"试卷列表";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self loadData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exitAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"input" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    YXIntelligenceQuestionListItem *listItem = [[YXIntelligenceQuestionListItem alloc]initWithString:json error:nil];
    self.paperArray = [NSMutableArray array];
    for (YXIntelligenceQuestion *paper in listItem.data) {
        [self.paperArray addObject:[QAPaperModel modelFromRawData:paper]];
    }
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.textLabel.text = self.paperArray[indexPath.row].paperTitle;
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showMenuForPaper:self.paperArray[indexPath.row]];
}

- (void)showMenuForPaper:(QAPaperModel *)model {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择展示方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *answerAction = [UIAlertAction actionWithTitle:@"答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self gotoAnswer:model];
    }];
    UIAlertAction *analysisAction = [UIAlertAction actionWithTitle:@"解析" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self gotoAnalysis:model];
    }];
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self gotoReport:model];
    }];
    UIAlertAction *redoAction = [UIAlertAction actionWithTitle:@"重做" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self gotoRedo:model];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:answerAction];
    [alertVC addAction:analysisAction];
    [alertVC addAction:reportAction];
    [alertVC addAction:redoAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)gotoAnswer:(QAPaperModel *)model {
    YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoAnalysis:(QAPaperModel *)model {
    QAAnalysisViewController *vc = [[QAAnalysisViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoReport:(QAPaperModel *)model {
    YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
    vc.model = model;
    vc.canDoExerciseAgain = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoRedo:(QAPaperModel *)model {
    MistakeRedoViewController *vc = [[MistakeRedoViewController alloc] init];
    QAPaperModel *newModel = [[QAPaperModel alloc]init];
    newModel.paperTitle = model.paperTitle;
    newModel.questions = [NSArray arrayWithArray:model.questions];
    vc.model = newModel;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

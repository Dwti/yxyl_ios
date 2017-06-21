//
//  YXPaperMainViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPaperMainViewController.h"
#import "YXQuestionFactory.h"
#import "YXPaperManager.h"
#import "YXAnswerQuestionViewController.h"
#import "YXComplexQuestionDetailViewController.h"
#import "YXSingleChooseDetailViewController.h"
#import "YXMultiChooseDetailViewController.h"
#import "YXYesNoDetailViewController.h"
#import "YXFillBlankDetailViewController.h"
#import "YXSubjectiveDetailViewController.h"
#import "YXJieXiViewController.h"
#import "YXQAAnalysisDataConfig.h"
#import "YXQAReportViewController.h"
#import "YXQuestionTemplateTypeMapper.h"
#import "YXConnectClassifyDetailViewController.h"
#import "YXImportPaperViewController.h"
#import "YXServerEnvHelper.h"
#import "MistakeRedoViewController.h"
#import "QAAnswerQuestionViewController.h"
#import "QAAnalysisViewController.h"

@interface YXPaperMainViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YXPaperMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addQuestionAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitAction)];
    self.navigationItem.leftBarButtonItem = leftItem;

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-180);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor redColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *qaButton = [self paperButtonWithTitle:@"进入答题"];
    qaButton.tag = 100;
    [self.view addSubview:qaButton];
    [qaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(-50);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    UIButton *anaButton = [self paperButtonWithTitle:@"进入解析"];
    anaButton.tag = 101;
    [self.view addSubview:anaButton];
    [anaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(qaButton.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(qaButton.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    UIButton *reportButton = [self paperButtonWithTitle:@"进入报告"];
    reportButton.tag = 102;
    [self.view addSubview:reportButton];
    [reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(anaButton.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(qaButton.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    UIButton *redoButton = [self paperButtonWithTitle:@"进入重做"];
    redoButton.tag = 103;
    [self.view addSubview:redoButton];
    [redoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reportButton.mas_top);
        make.bottom.mas_equalTo(reportButton.mas_bottom);
        make.left.mas_equalTo(reportButton.mas_right).mas_offset(5);
        make.width.mas_equalTo(reportButton.mas_width);
    }];
    
    UIButton *menuButton = [self paperButtonWithTitle:@"菜单"];
    [menuButton removeTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(40);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (UIButton *)paperButtonWithTitle:(NSString *)title{
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton setTitle:title forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.borderWidth = 1;
    submitButton.layer.borderColor = [UIColor blueColor].CGColor;
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    return submitButton;
}

- (void)addQuestionAction{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加试题" message:@"请选择您想添加的模版题型到试卷中" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *singleChooseAction = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemSingleChoose template:YXQATemplateSingleChoose]];
        [self.tableView reloadData];
    }];
    UIAlertAction *multiChooseAction = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemMultiChoose template:YXQATemplateMultiChoose]];
        [self.tableView reloadData];
    }];
    UIAlertAction *yesNoAction = [UIAlertAction actionWithTitle:@"判断" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemYesNo template:YXQATemplateYesNo]];
        [self.tableView reloadData];
    }];
    UIAlertAction *fillAction = [UIAlertAction actionWithTitle:@"填空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemFill template:YXQATemplateFill]];
        [self.tableView reloadData];
    }];
    UIAlertAction *subjectiveAction = [UIAlertAction actionWithTitle:@"问答" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemSubjective template:YXQATemplateSubjective]];
        [self.tableView reloadData];
    }];
    UIAlertAction *classifyAction = [UIAlertAction actionWithTitle:@"归类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemClassify template:YXQATemplateClassify]];
        [self.tableView reloadData];
    }];
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"连线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemConnect template:YXQATemplateConnect]];
        [self.tableView reloadData];
    }];
    UIAlertAction *readComplexAction = [UIAlertAction actionWithTitle:@"复合" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemRead template:YXQATemplateReadComplex]];
        [self.tableView reloadData];
    }];
    UIAlertAction *clozeComplexAction = [UIAlertAction actionWithTitle:@"完形填空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemCloze template:YXQATemplateClozeComplex]];
        [self.tableView reloadData];
    }];
    UIAlertAction *listenComplexAction = [UIAlertAction actionWithTitle:@"听力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [[YXPaperManager sharedInstance].questions addObject:[YXQuestionFactory questionWithType:YXQAItemListenAudioChoose template:YXQATemplateListenComplex]];
        [self.tableView reloadData];
    }];
    
    [alertVC addAction:backAction];
    [alertVC addAction:singleChooseAction];
    [alertVC addAction:multiChooseAction];
    [alertVC addAction:yesNoAction];
    [alertVC addAction:fillAction];
    [alertVC addAction:subjectiveAction];
    [alertVC addAction:classifyAction];
    [alertVC addAction:connectAction];
    [alertVC addAction:readComplexAction];
    [alertVC addAction:clozeComplexAction];
    [alertVC addAction:listenComplexAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)exitAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitAction:(UIButton *)sender{
    if ([YXPaperManager sharedInstance].questions.count == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"题目为空" message:@"请您至少添加一道题到试卷中" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:backAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    QAPaperModel *model = [[YXPaperManager sharedInstance]modelFromPaper];
    if (sender.tag == 100) { // 答题
        QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 101){ // 解析
        QAAnalysisViewController *vc = [[QAAnalysisViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 102){ // 报告
        YXQAReportViewController *vc = [[YXQAReportViewController alloc] init];
        vc.model = model;
        vc.canDoExerciseAgain = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 103){ // 重做
        MistakeRedoViewController *vc = [[MistakeRedoViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)titleFromQuestion:(YXQuestion *)question{
    NSDictionary *templateDic = [YXQuestionTemplateTypeMapper questionTemplateDictionary];
    NSString *templateName = [templateDic valueForKey:question.qTemplate];
    NSDictionary *typeDic = [YXQuestionTemplateTypeMapper questionTypeDictionary];
    NSString *typeName = [typeDic valueForKey:question.type_id];
    if (question.identifierForTest.length > 0) {
        return [NSString stringWithFormat:@"%@-%@-%@",templateName,typeName,question.identifierForTest];
    }
    return [NSString stringWithFormat:@"%@-%@",templateName,typeName];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [YXPaperManager sharedInstance].questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    YXIntelligenceQuestion_PaperTest *q = [YXPaperManager sharedInstance].questions[indexPath.row];
    cell.textLabel.text = [self titleFromQuestion:q.questions];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXIntelligenceQuestion_PaperTest *paperTest = [YXPaperManager sharedInstance].questions[indexPath.row];
    YXQuestion *q = paperTest.questions;
    if ([q templateType] == YXQATemplateReadComplex
        || [q templateType] == YXQATemplateClozeComplex
        || [q templateType] == YXQATemplateListenComplex) {
        YXComplexQuestionDetailViewController *vc = [[YXComplexQuestionDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateSingleChoose){
        YXSingleChooseDetailViewController *vc = [[YXSingleChooseDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateMultiChoose){
        YXMultiChooseDetailViewController *vc = [[YXMultiChooseDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateYesNo){
        YXYesNoDetailViewController *vc = [[YXYesNoDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateFill) {
        YXFillBlankDetailViewController *vc = [[YXFillBlankDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateSubjective){
        YXSubjectiveDetailViewController *vc = [[YXSubjectiveDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateConnect){
        YXConnectClassifyDetailViewController *vc = [[YXConnectClassifyDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([q templateType] == YXQATemplateClassify){
        YXConnectClassifyDetailViewController *vc = [[YXConnectClassifyDetailViewController alloc]init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[YXPaperManager sharedInstance].questions removeObjectAtIndex:indexPath.row];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark - Menu Functions
- (NSString *)paperFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    docDir = [docDir stringByAppendingPathComponent:@"Papers"];
    BOOL isDir;
    NSError *error;
    if (![[NSFileManager defaultManager]fileExistsAtPath:docDir isDirectory:&isDir]||!isDir) {
        [[NSFileManager defaultManager]createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return docDir;
}
- (NSArray *)allPapers{
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager]contentsOfDirectoryAtURL:[NSURL fileURLWithPath:[self paperFolder]] includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *file in files) {
        [array addObject:file.lastPathComponent];
    }
    return array;
}
- (void)menuAction{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"菜单" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存试卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self savePaper];
    }];
    UIAlertAction *importAction = [UIAlertAction actionWithTitle:@"导入试卷" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self importPaper];
    }];
    UIAlertAction *envAction = [UIAlertAction actionWithTitle:@"环境设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self changeEnv];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:saveAction];
    [alertVC addAction:importAction];
    [alertVC addAction:envAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)savePaper{
    if ([YXPaperManager sharedInstance].questions.count == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"题目为空" message:@"请您至少添加一道题到试卷中" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:backAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入试卷名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        STRONG_SELF
        textField.delegate = self;
    }];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *folderPath = [self paperFolder];
    NSArray *files = [self allPapers];
    for (NSString *file in files) {
        if ([file isEqualToString:textField.text]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"名称已存在" message:@"请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            WEAK_SELF
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                STRONG_SELF
                textField.delegate = self;
            }];
            [alertVC addAction:confirmAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    }
    NSString *filePath = [folderPath stringByAppendingPathComponent:textField.text];
    NSString *json = [[YXPaperManager sharedInstance]paperJsonString];
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:data attributes:nil];
    NSLog(@"%@",textField.text);
}

- (void)importPaper{
    YXImportPaperViewController *vc = [[YXImportPaperViewController alloc]init];
    vc.papers = [self allPapers];
    WEAK_SELF
    vc.completeBlock = ^(NSString *paper){
        NSLog(@"paper: %@",paper);
        STRONG_SELF
        NSString *filePath = [[self paperFolder] stringByAppendingPathComponent:paper];
        NSData *data = [[NSFileManager defaultManager]contentsAtPath:filePath];
        YXIntelligenceQuestion *intelQues = [[YXIntelligenceQuestion alloc]initWithData:data error:nil];
        [YXPaperManager sharedInstance].questions = [NSMutableArray arrayWithArray:intelQues.paperTest];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeEnv{
    NSString *test = @"测试环境";
    NSString *dev = @"开发环境";
    NSString *rel = @"正式环境";
    YXServerEnv env = [YXServerEnvHelper currentEnv];
    if (env == YXServerEnv_Test) {
        test = [test stringByAppendingString:@"(当前)"];
    }else if (env == YXServerEnv_Dev) {
        dev = [dev stringByAppendingString:@"(当前)"];
    }else if (env == YXServerEnv_Rel) {
        rel = [rel stringByAppendingString:@"(当前)"];
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"环境设置" message:@"需要重启APP生效" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *testAction = [UIAlertAction actionWithTitle:test style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [YXServerEnvHelper setServerEnv:YXServerEnv_Test];
    }];
    UIAlertAction *devAction = [UIAlertAction actionWithTitle:dev style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [YXServerEnvHelper setServerEnv:YXServerEnv_Dev];
    }];
    UIAlertAction *relAction = [UIAlertAction actionWithTitle:rel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [YXServerEnvHelper setServerEnv:YXServerEnv_Rel];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:testAction];
    [alertVC addAction:devAction];
    [alertVC addAction:relAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end

//
//  YXComplexQuestionDetailViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXComplexQuestionDetailViewController.h"
#import "YXChooseDetailViewController.h"
#import "YXSingleChooseDetailViewController.h"
#import "YXMultiChooseDetailViewController.h"
#import "YXYesNoDetailViewController.h"
#import "YXFillBlankDetailViewController.h"
#import "YXSubjectiveDetailViewController.h"
#import "YXQuestionTemplateTypeMapper.h"
#import "YXQuestionTypeSelectionViewController.h"
#import "YXConnectClassifyDetailViewController.h"
#import "YXOralDetailViewController.h"

@interface YXComplexQuestionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YXComplexQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"复合题配置";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addQuestionAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self.typeButton setTitle:[[YXQuestionTemplateTypeMapper questionTypeDictionary] valueForKey:self.question.type_id] forState:UIControlStateNormal];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.numberOfLines = 0;
    self.descLabel.text = @"点击添加给复合题增加小题";
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.text = @"题型:";
    [self.view addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(10);
    }];
    self.typeButton = [[UIButton alloc]init];
    [self.typeButton setTitle:[[YXQuestionTemplateTypeMapper questionTypeDictionary] valueForKey:self.question.type_id] forState:UIControlStateNormal];
    [self.typeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.typeButton.layer.cornerRadius = 3;
    self.typeButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.typeButton.layer.borderWidth = 1;
    [self.typeButton addTarget:self action:@selector(typeSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.typeButton];
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(20);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.identifierLabel = [[UILabel alloc]init];
    self.identifierLabel.text = @"题目标识符:";
    [self.view addSubview:self.identifierLabel];
    [self.identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(20);
    }];
    self.identifierField = [[UITextField alloc]init];
    self.identifierField.borderStyle = UITextBorderStyleRoundedRect;
    self.identifierField.placeholder = @"如果需要请输入";
    self.identifierField.text = self.question.identifierForTest;
    self.identifierField.returnKeyType = UIReturnKeyDone;
    self.identifierField.delegate = self;
    [self.view addSubview:self.identifierField];
    [self.identifierField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.identifierLabel.mas_right).mas_offset(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.identifierLabel.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor redColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.identifierField.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)typeSelectAction{
    YXQuestionTypeSelectionViewController *vc = [[YXQuestionTypeSelectionViewController alloc]init];
    vc.question = self.question;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backAction{
    if (self.question.children.count == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"题目为空" message:@"请您至少添加一道小题到复合题中" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:backAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (YXIntelligenceQuestion_PaperTest *paperTest in self.question.children) {
        YXQuestion *q = paperTest.questions;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:q.aid forKey:@"qid"];
        [dic setValue:q.pad.jsonAnswer forKey:@"answer"];
        [array addObject:dic];
    }
    self.question.pad.jsonAnswer = array;
    
    self.question.identifierForTest = self.identifierField.text;
    
    if ([self.question templateType] == YXQATemplateClozeComplex) {
        NSString *stem = @"这是一道完形填空题 :";
        for (int i=0; i<self.question.children.count; i++) {
            NSString *s = [NSString stringWithFormat:@"第%@道题 bfeb gerb gkegb kerb gireb gkebg kerbnk eb k ernk 4nhk4 ny4k5y的答案是 (_).",@(i+1)];
            stem = [stem stringByAppendingString:s];
        }
        self.question.stem = stem;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addQuestionAction{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加试题" message:@"请选择您想添加的小题到复合题中" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAK_SELF
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *singleChooseAction = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemSingleChoose template:YXQATemplateSingleChoose]];
    }];
    UIAlertAction *multiChooseAction = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemMultiChoose template:YXQATemplateMultiChoose]];
    }];
    UIAlertAction *yesNoAction = [UIAlertAction actionWithTitle:@"判断" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemYesNo template:YXQATemplateYesNo]];
    }];
    UIAlertAction *fillAction = [UIAlertAction actionWithTitle:@"填空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemFill template:YXQATemplateFill]];
    }];
    UIAlertAction *subjectiveAction = [UIAlertAction actionWithTitle:@"问答" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemSubjective template:YXQATemplateSubjective]];
    }];
    UIAlertAction *classifyAction = [UIAlertAction actionWithTitle:@"归类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemClassify template:YXQATemplateClassify]];
    }];
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"连线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemConnect template:YXQATemplateConnect]];
    }];
    UIAlertAction *oralAction = [UIAlertAction actionWithTitle:@"口语" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self addQuestion:[YXQuestionFactory questionWithType:YXQAItemOralRead template:YXQATemplateOral]];
    }];
    [alertVC addAction:backAction];
    [alertVC addAction:singleChooseAction];
    if ([self.question templateType] != YXQATemplateClozeComplex) {
        [alertVC addAction:multiChooseAction];
        [alertVC addAction:yesNoAction];
        [alertVC addAction:fillAction];
        [alertVC addAction:subjectiveAction];
        [alertVC addAction:classifyAction];
        [alertVC addAction:connectAction];
        [alertVC addAction:oralAction];
    }
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)addQuestion:(YXIntelligenceQuestion_PaperTest *)q{
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.question.children];
    [mArray addObject:q];
    self.question.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)[NSArray arrayWithArray:mArray];
    [self.tableView reloadData];
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
    return self.question.children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    YXIntelligenceQuestion_PaperTest *q = self.question.children[indexPath.row];
    cell.textLabel.text = [self titleFromQuestion:q.questions];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXIntelligenceQuestion_PaperTest *paperTest = self.question.children[indexPath.row];
    YXQuestion *q = paperTest.questions;
    if ([q templateType] == YXQATemplateSingleChoose){
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
    }else if ([q templateType] == YXQATemplateOral) {
        YXOralDetailViewController *vc = [[YXOralDetailViewController alloc] init];
        vc.question = q;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.question.children];
    [array removeObjectAtIndex:indexPath.row];
    self.question.children = (NSArray<YXIntelligenceQuestion_PaperTest,Optional> *)array;
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end

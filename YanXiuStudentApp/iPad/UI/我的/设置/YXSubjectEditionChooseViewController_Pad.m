//
//  YXSubjectEditionChooseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSubjectEditionChooseViewController_Pad.h"
#import "YXEditionListChooseViewController_Pad.h"
#import "YXSubjectImageHelper.h"
#import "YXGetSubjectRequest.h"

@interface YXSubjectEditionChooseViewController_Pad ()

@property (nonatomic, strong) YXNodeElementListItem *item;

@end

@implementation YXSubjectEditionChooseViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教材版本";
    
    [self requestSubjects];
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[YXGetSubjectManager sharedManager] stopRequest];
}

- (void)requestSubjects
{
    self.item = [[YXGetSubjectManager sharedManager] subjectItem];
    if (self.item.data) {
        [self.tableView reloadData];
        return;
    }
    
    [self yx_startLoading];
    [[YXGetSubjectManager sharedManager] requestCompeletion:^(YXNodeElementListItem *item, NSError *error) {
        [self yx_stopLoading];
        self.item = item;
        if (self.item) {
            [self.tableView reloadData];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(saveEditionInfoSuccess)
                   name:YXSubjectSaveEditionInfoSuccessNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveEditionInfoSuccess
{
    self.item = [[YXGetSubjectManager sharedManager] subjectItem];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    YXNodeElement *subject = self.item.data[indexPath.row];
    [cell setTitle:subject.name image:[UIImage imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.eid integerValue]]]];
    NSString *editionName = subject.data.editionName;
    if (![editionName yx_isValidString]) {
        editionName = @"未选择版本";
    }
    [cell updateWithAccessoryText:editionName isBoldFont:YES];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXEditionListChooseViewController_Pad *vc = [[YXEditionListChooseViewController_Pad alloc] init];
    vc.subject = self.item.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

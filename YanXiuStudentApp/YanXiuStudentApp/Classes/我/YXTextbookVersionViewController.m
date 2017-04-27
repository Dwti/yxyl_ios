//
//  YXTextbookVersionViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXTextbookVersionViewController.h"
#import "YXMineTableViewCell.h"
#import "YXSubjectImageHelper.h"
#import "YXChooseEditionViewController.h"
#import "ExerciseSubjectManager.h"

@interface YXTextbookVersionViewController ()
@property (nonatomic, strong) GetSubjectRequestItem *item;
@end

@implementation YXTextbookVersionViewController
- (void)dealloc {
    [self removeNotifications];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教材版本";
    [self yx_setupLeftBackBarButtonItem];
    
    [self requestSubjects];
    [self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestSubjects {
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    if (self.item.subjects) {
        [self.tableView reloadData];
        return;
    }
    [self yx_startLoading];
    [[ExerciseSubjectManager sharedInstance] requestSubjectsWithCompleteBlock:^(GetSubjectRequestItem *retItem, NSError *error) {
        [self yx_stopLoading];
        self.item = retItem;
        if (self.item) {
            [self.tableView reloadData];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}
- (void)registerNotifications {
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(saveEditionInfoSuccess)
                   name:kSubjectSaveEditionInfoSuccessNotification
                 object:nil];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)saveEditionInfoSuccess {
    self.item = [[ExerciseSubjectManager sharedInstance] currentSubjectItem];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.subjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    GetSubjectRequestItem_subject *subject = self.item.subjects[indexPath.row];
    [cell setTitle:subject.name image:[UIImage imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.subjectID integerValue]]]];
    NSString *editionName = subject.edition.editionName;
    if (![editionName yx_isValidString]) {
        editionName = @"未选择版本";
    }
    [cell updateWithAccessoryText:editionName];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXChooseEditionViewController *chooseEditionVC = [[YXChooseEditionViewController alloc] init];
    chooseEditionVC.subject = self.item.subjects[indexPath.row];
    [self.navigationController pushViewController:chooseEditionVC animated:YES];
}

@end

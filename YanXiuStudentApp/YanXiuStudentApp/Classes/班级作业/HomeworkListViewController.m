//
//  HomeworkListViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkListViewController.h"
#import "YXHomeworkListFetcher.h"
#import "HomeworkListCell.h"
#import "QAAnswerQuestionViewController.h"
#import "QAReportViewController.h"

@interface HomeworkListViewController ()
@property (nonatomic, strong) YXHomeworkListGroupsItem_Data *data;

@end

@implementation HomeworkListViewController

- (instancetype)initWithData:(YXHomeworkListGroupsItem_Data *)data {
    if (self = [super init]) {
        self.data = data;
        YXHomeworkListFetcher *fetcher = [[YXHomeworkListFetcher alloc] init];
        fetcher.gid = data.groupId;
        self.dataFetcher = fetcher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.data.name;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerClass:[HomeworkListCell class] forCellReuseIdentifier:@"HomeworkListCell"];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSavePaperSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSubmitQuestionSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
}

#pragma mark - tableview datasource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListCell"];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self requestWithHomework:self.dataArray[indexPath.row]];
}

- (void)requestWithHomework:(YXHomework *)homework {
    NSInteger status = [homework.paperStatus.status integerValue];
    switch (status) {
        case 0: // 进入答题界面（0 待完成）
        {
            WEAK_SELF
            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
                STRONG_SELF
                QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.pType = YXPTypeGroupHomework;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 1: // 进入解析界面（1 未完成）
        {
//            WEAK_SELF
//            [self requestQuestionListWithHomework:homework completion:^(YXIntelligenceQuestionListItem *item, NSError *error) {
//                STRONG_SELF
//                YXJieXiViewController *vc = [[YXJieXiViewController alloc] init];
//                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
//                vc.pType = YXPTypeGroupHomework;
//                vc.analysisDataDelegate = [[YXQAAnalysisDataConfig alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }];
        }
            break;
        case 2: // 进入答题报告界面（2 已完成）
        {
            [self requestReportWithHomework:homework];
        }
            break;
        default:
            break;
    }
}

- (void)requestQuestionListWithHomework:(YXHomework *)homework
                             completion:(void(^)(YXIntelligenceQuestionListItem *item, NSError *error))completeBlock {
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager getQuestionListWithPaperID:homework.paperId completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            BLOCK_EXEC(completeBlock,item,nil);
        }
    }];
}

- (void)requestReportWithHomework:(YXHomework *)homework {
    if (![homework shouldDisplayTheReport]) { //暂不显示报告
        [self.view nyx_showToast:[NSString stringWithFormat:@"%@之后才能查看报告", homework.overTime]];
        return;
    }
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager getQuestionReportWithPaperID:homework.paperId completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if (item.data.count > 0) {
            YXIntelligenceQuestion *question = item.data[0];
            QAReportViewController *vc = [[QAReportViewController alloc] init];
            vc.model = [QAPaperModel modelFromRawData:question];
//            vc.pType = YXPTypeGroupHomework;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end

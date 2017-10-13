//
//  BCTopicListViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicListViewController.h"
#import "BCTopicListCell.h"
#import "BCTopicListFetcher.h"
#import "TestViewController.h"
#import "BCTopicFilterView.h"
#import "GetTopicTreeRequest.h"
#import "BCTopicPaper.h"
#import "BCResourceDataManager.h"
#import "QAReportViewController.h"
#import "QAAnswerQuestionViewController.h"

@interface BCTopicListViewController ()
@property (nonatomic, strong) GetTopicTreeRequestItem_theme *topicTheme;
@property (nonatomic, copy) NSString *type;
@property(nonatomic, strong) BCTopicFilterView *filterView;
@property(nonatomic, copy) NSString *order; //0-字母升序，1-字母降序，10-浏览数降序
@property(nonatomic, copy) NSString *scope; //查询范围 0-全部，1-已做答，2-未作答

@end

@implementation BCTopicListViewController

- (instancetype)initWithTopicTheme:(GetTopicTreeRequestItem_theme *)topicTheme type:(NSString *)type{
    if (self = [super init]) {
        self.topicTheme = topicTheme;
        self.type = type;
        self.order = @"0";
        self.scope = @"0";
        BCTopicListFetcher *dataFetcher = [[BCTopicListFetcher alloc]init];
        dataFetcher.type = self.type;
        dataFetcher.topicId = self.topicTheme.themeId;
        dataFetcher.order = self.order;
        dataFetcher.scope = self.scope;
        self.dataFetcher = dataFetcher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.topicTheme.name;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.naviTheme = NavigationBarTheme_White;
    self.emptyView.title = @"内容为空";
    self.emptyView.image = [UIImage imageNamed:@"没有练习历史插图"];
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55.f);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55.f);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self setupUI];
    [self setupObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.filterView = [[BCTopicFilterView alloc]init];
    WEAK_SELF
    [self.filterView setAlphabeticallyBlock:^(BOOL isFilterByAlphabetically, BOOL isPositiveSequence) {
        STRONG_SELF
        [self.filterView answerStateFilterAbort];
        if (isFilterByAlphabetically) {
            self.order = isPositiveSequence== YES ? @"0" : @"1";
        }
        BCTopicListFetcher *dataFetcher = (BCTopicListFetcher *)self.dataFetcher;
        dataFetcher.order = self.order;
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [self.filterView setPopularityRankBlock:^(BOOL isFilterByPopularityRank) {
        STRONG_SELF
        [self.filterView answerStateFilterAbort];
        if (isFilterByPopularityRank) {
            self.order = @"10";
        }
        BCTopicListFetcher *dataFetcher = (BCTopicListFetcher *)self.dataFetcher;
        dataFetcher.order = self.order;
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [self.filterView setAnswerstateFilterBlock:^(NSString *answerStateFilter) {
        STRONG_SELF
        self.scope = answerStateFilter;
        BCTopicListFetcher *dataFetcher = (BCTopicListFetcher *)self.dataFetcher;
        dataFetcher.scope = self.scope;
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [self.view addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(55.f);
    }];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110.f;
    [self.tableView registerClass:[BCTopicListCell class] forCellReuseIdentifier:@"BCTopicListCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.filterView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
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
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXSubmitQuestionPaperNotExistNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kResetTopicPaperHistorySuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self.view nyx_startLoading];
        [self firstPageFetch];
    }];
}

#pragma mark - tableview datasource & delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTopicListCell *cell = [[BCTopicListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.topicPaper = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BCTopicPaper *topicPaper = self.dataArray[indexPath.row];
    if ([topicPaper.paperStatus.status isEqualToString:@"2"]) {//已作答
        //进入报告
        [self requestReportWithTopicPaper:topicPaper];
    }else {
        //进入答题
        WEAK_SELF
        [self.view nyx_startLoading];
        [BCResourceDataManager requestTopicPaperQuestionWithPaperID:topicPaper.rmsPaperId type:self.type completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
            STRONG_SELF
            [self.view nyx_stopLoading];
            if (error) {
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            if (item.data.count > 0) {
                QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
                vc.model = [QAPaperModel modelFromRawData:item.data[0]];
                vc.pType = YXPTypeBCResourceExercise;
                vc.rmsPaperId = topicPaper.rmsPaperId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
//    TestViewController *vc = [[TestViewController alloc]init];
//    vc.url = @"http://yuncdn.teacherclub.com.cn/course/cf/xk/czsw/jxsjdysjbkjy/video/1.1_l/1.1_l.m3u8";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestReportWithTopicPaper:(BCTopicPaper *)topicPaper {
    [self.view nyx_startLoading];
    WEAK_SELF
    [BCResourceDataManager getQuestionReportWithPaperID:topicPaper.paperStatus.ppid completeBlock:^(YXIntelligenceQuestionListItem *item, NSError *error) {
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
            vc.pType = YXPTypeBCResourceExercise;
            vc.rmsPaperId = topicPaper.rmsPaperId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end

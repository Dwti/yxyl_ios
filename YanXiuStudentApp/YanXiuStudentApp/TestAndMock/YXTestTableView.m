//
//  YXTestTableView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXTestTableView.h"
#import "YXAllHeaders.h"
#import "YXHtmlCell.h"

@interface YXTestTableView () <YXHtmlCellDelegate>
@end

@implementation YXTestTableView {
    NSMutableArray *_heightArray;
}
- (void)viewDidLoad {
    [self _setupMock_];
    [super viewDidLoad];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[YXHtmlCell class] forCellReuseIdentifier:@"YXHtmlCell"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 300, 44, 44);
    btn.backgroundColor = [UIColor greenColor];
    [self.tableView addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXHtmlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHtmlCell"];
    [cell updateWithData:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)htmlCell:(YXHtmlCell *)cell updateWithHeight:(CGFloat)height {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        if (!ip) {
            return;
        }
        
        CGFloat h = [_heightArray[ip.row] floatValue];
        CGFloat nh = ceilf(height);
        
        
        if (h != nh) {
            NSLog(@"%@, row", @(ip.row));
            [_heightArray replaceObjectAtIndex:ip.row withObject:@(nh)];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
        }
}

/*
- (void)_setupMock_ {
    YXHomeworkGroupMock *m0 = [[YXHomeworkGroupMock alloc] init];
    m0.iconUrl = [[NSBundle mainBundle] URLForResource:@"智能练习-语文@2x" withExtension:@"png"];
    m0.name = @"三年二班语文";
    m0.homeworkInfo = @"最新作业：6月3日语文作业";
    m0.state = HomeworkGroupState_Ongoing;
    
    YXHomeworkGroupMock *m1 = [[YXHomeworkGroupMock alloc] init];
    m1.iconUrl = [[NSBundle mainBundle] URLForResource:@"智能练习-语文@2x" withExtension:@"png"];
    m1.name = @"三年二班语文";
    m1.homeworkInfo = @"审核中，暂无法进入群组";
    m1.state = HomeworkGroupState_Verifying;
    
    YXHomeworkGroupMock *m2 = [[YXHomeworkGroupMock alloc] init];
    m2.iconUrl = [[NSBundle mainBundle] URLForResource:@"智能练习-语文@2x" withExtension:@"png"];
    m2.name = @"三年二班语文";
    m2.homeworkInfo = @"未审核通过";
    m2.state = HomeworkGroupState_Denied;
    
    YXHomeworkGroupMock *m3 = [[YXHomeworkGroupMock alloc] init];
    m3.iconUrl = [[NSBundle mainBundle] URLForResource:@"智能练习-语文@2x" withExtension:@"png"];
    m3.name = @"三年二班语文";
    m3.homeworkInfo = @"最新作业：6月1日语文作业";
    m3.state = HomeworkGroupState_Finished;
    
    self.dataArray = @[m0, m1, m2, m3];
}*/

/*
- (void)_setupMock_ {
    YXClassInfoMock *data = [[YXClassInfoMock alloc] init];
    
    data.iconUrl = [[NSBundle mainBundle] URLForResource:@"班级信息-头像@2x" withExtension:@"png"];
    data.name = @"三年二班语文";
    data.gid = @"TC1088";
    data.grade = @"三年级";
    data.subject = @"语文";
    data.teacher = @"何不为";
    data.headcount = @"48";
    
    self.dataArray= @[data];
}*/

- (void)_setupMock_ {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *heightArr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {

        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", @(i%3)] ofType:@"html"];
        [arr addObject:path];
        [heightArr addObject:@(44)];
    }
    self.dataArray = [NSArray arrayWithArray:arr];
    _heightArray = heightArr;
    //[NSMutableArray arrayWithArray:@[@30, @70, @67]];
}

- (void)btnAction {
    
}
@end

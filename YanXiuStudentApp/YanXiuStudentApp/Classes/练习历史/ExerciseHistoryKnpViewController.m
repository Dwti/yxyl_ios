//
//  ExerciseHistoryKnpViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryKnpViewController.h"
#import "YXExerciseHistoryListFetcher.h"

@interface ExerciseHistoryKnpViewController ()

@end

@implementation ExerciseHistoryKnpViewController

- (instancetype)init {
    if (self = [super init]) {
        self.segment = YXExerciseListSegmentTestItem;
    }
    return self;
}

- (void)viewDidLoad {
    YXExerciseHistoryByKnowListFetcher *fetcher = [[YXExerciseHistoryByKnowListFetcher alloc] init];
    fetcher.subject = self.subject;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

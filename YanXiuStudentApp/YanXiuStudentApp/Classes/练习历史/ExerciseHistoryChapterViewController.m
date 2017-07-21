//
//  ExerciseHistoryChapterViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryChapterViewController.h"
#import "YXExerciseHistoryListFetcher.h"

@interface ExerciseHistoryChapterViewController ()

@end

@implementation ExerciseHistoryChapterViewController

- (instancetype)init {
    if (self = [super init]) {
        self.segment = YXExerciseListSegmentChapter;
    }
    return self;
}

- (void)viewDidLoad {
    YXExerciseHistoryListFetcher *fetcher = [[YXExerciseHistoryListFetcher alloc] init];
    fetcher.subject = self.subject;
    fetcher.volumeID = self.volumeID;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVolumeID:(NSString *)volumeID {
    _volumeID = volumeID;
    YXExerciseHistoryListFetcher *fetcher = (YXExerciseHistoryListFetcher *)self.dataFetcher;
    fetcher.volumeID = _volumeID;
    [self firstPageFetch];
}

@end

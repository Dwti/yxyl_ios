//
//  YXTestViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/2/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "YXTestViewController.h"
#import "YXAllHeaders.h"
#import "YXMockPageRequest.h"
#import <FileHash.h>
#import "LoginViewController.h"


@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"登录注册",
                            @"作业",
                            @"加入班级",
                            @"题目",
                            @"解析",
                            @"testClassify",
                            @"testYXAnswerQuestionViewController",
                            @"testCells",
                            @"testGet",
                            @"testPost",
                            @"testUpload",
                            @"testYXTestBaseViewController",
                            @"testYXSmartExerciseViewController",
                            @"testCoreText",
                            @"testYXScrollViewController",
                            @"testYXFillBlankViewController",
                            @"testPhotoClip",
                            @"testImagePicker",
                            @"蔡雷_01",
                            ];
    [super viewDidLoad];
}
- (void)testPhotoClip {
    QAPhotoClipViewController *vc = [[QAPhotoClipViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)作业 {
    HomeworkMainViewController *vc = [[HomeworkMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)加入班级 {
    AddClassViewController *vc = [[AddClassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)登录注册 {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //    YXTestAutolayoutScrollViewController *vc = [[YXTestAutolayoutScrollViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)题目 {
    YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)解析 {
    YXJieXiViewController *vc = [[YXJieXiViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testYXAnswerQuestionViewController {
    QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testYXHomeworkGroupViewController {
    YXHomeworkGroupViewController *vc = [[YXHomeworkGroupViewController alloc] init];
    vc.bHasUnfinished = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testCells {
    YXTestTableView *vc = [[YXTestTableView alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:vc animated:YES];
}

TestGetRequest *_TestGetRequest;
- (void)testGet {
    _TestGetRequest = [[TestGetRequest alloc] init];
    _TestGetRequest.token = @"626321fffff4cef363b4449073646607";
    [_TestGetRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                             andCompleteBlock:^(id retItem, NSError *error) {
                                 
                             }];
}

TestPostRequest *_TestPostRequest;
- (void)testPost {
    _TestPostRequest = [[TestPostRequest alloc] init];
    _TestPostRequest.token = @"626321fffff4cef363b4449073646607";
    _TestPostRequest.pid = @"136";
    _TestPostRequest.puid = @"3757464";
    _TestPostRequest.type = @"1";
    _TestPostRequest.islike = @"1";
    [_TestPostRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                              andCompleteBlock:^(id retItem, NSError *error) {
                                  
                              }];
}

//token	626321fffff4cef363b4449073646607
//action	upload
//title	refactor.test
//hashCode

TestUploadRequest *_TestUploadRequest;
- (void)testUpload {
    _TestUploadRequest = [[TestUploadRequest alloc] init];
    _TestUploadRequest.token = @"626321fffff4cef363b4449073646607";
    _TestUploadRequest.action = @"upload";
    _TestUploadRequest.title = @"refactor.test";
    
    /*/
     NSString *dataContent = @"Hello World";
     _TestUploadRequest.hashCode = [dataContent md5];
     [[_TestUploadRequest request] setData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]
     withFileName:@"refactor.test"
     andContentType:nil
     forKey:@"file"];
     //*/
    
    //*/
    NSString *filepath = @"/Users/cailei/yxAll/usedResouce/11MB.pdf";
    _TestUploadRequest.hashCode = [FileHash md5HashOfFileAtPath:filepath];
    [[_TestUploadRequest request] setFile:filepath
                             withFileName:@"refactor.test"
                           andContentType:nil
                                   forKey:@"file"];
    //*/
    
    
    __block unsigned long long sentBytes = 0;
    @weakify(self);
    [[_TestUploadRequest request] setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        @strongify(self); if (!self) return;
        sentBytes += size;
        
        CGFloat progress = (CGFloat)(sentBytes) / (CGFloat)total;
        DDLogError(@"%@", @(progress));
    }];
    
    [_TestUploadRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                                andCompleteBlock:^(id retItem, NSError *error) {
                                    
                                }];
}

- (void)testYXTestBaseViewController {
    YXTestBaseViewController *vc = [[YXTestBaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)testYXSmartExerciseViewController {
//    YXSmartExerciseViewController *vc = [[YXSmartExerciseViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testCoreText {
    YXTestCoreTextViewController *vc = [[YXTestCoreTextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testYXScrollViewController {

}

- (void)testYXFillBlankViewController {
    YXFillBlankViewController *vc = [[YXFillBlankViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testClassify{
    TestClassifyViewController *vc = [[TestClassifyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)testImagePicker{
    TestImagePickerViewController *vc = [[TestImagePickerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)蔡雷_01 {
    YXCaileiViewController01 *vc = [[YXCaileiViewController01 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

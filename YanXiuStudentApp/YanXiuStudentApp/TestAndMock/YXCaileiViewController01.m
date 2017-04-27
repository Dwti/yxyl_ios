//
//  YXCaileiViewController01.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/3/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXCaileiViewController01.h"
#import "YXExerciseChooseEdition_SubjectView.h"

@interface YXCaileiViewController01 ()

@end

@implementation YXCaileiViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YXExerciseChooseEdition_SubjectView *v = [[YXExerciseChooseEdition_SubjectView alloc] init];
    v.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [self.view addSubview:v];
}

@end

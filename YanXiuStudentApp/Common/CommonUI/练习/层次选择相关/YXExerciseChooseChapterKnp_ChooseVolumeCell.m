//
//  YXExerciseChooseChapterKnp_ChooseVolumeCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/29/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseChapterKnp_ChooseVolumeCell.h"

@implementation YXExerciseChooseChapterKnp_ChooseVolumeCell

- (void)layoutSubviews {
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
    }];

    [super layoutSubviews];
}
@end

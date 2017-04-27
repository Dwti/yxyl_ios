//
//  YXExerciseHomeworkCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXExerciseHomeworkType) {
    YXExercise,
    YXHomework
};

@interface YXExerciseHomeworkCell_Pad : UITableViewCell

@property (nonatomic, assign) YXExerciseHomeworkType type;
@property (nonatomic, copy) NSString *redNumber;

@end

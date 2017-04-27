//
//  VoiceCommentCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/22/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface AudioCommentCell : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *analysisItem;
@property (nonatomic, strong) QAQuestion *questionItem;
- (void)stop;
+ (CGFloat)heightForAudioComment:(NSArray *)array;
@end

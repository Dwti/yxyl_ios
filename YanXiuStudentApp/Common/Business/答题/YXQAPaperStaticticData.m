//
//  YXQAPaperStaticticData.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAPaperStaticticData.h"

@implementation YXQAPaperStaticticData
+ (YXQAPaperStaticticData *)dataFromQAModel:(QAPaperModel *)model{
    YXQAPaperStaticticData *data = [[YXQAPaperStaticticData alloc]init];
//    NSInteger correct = 0, wrong = 0, unAnswer = 0;
//    NSInteger answered = 0; // 主观题已作答的数目
//    NSInteger subjectiveCount = 0; // 主观题数目
//    CGFloat subjectiveScore = 0;
//    for (YXQAItemBase *item in model.itemArray) {
//        if ([item isKindOfClass:[YXQAComplexItem class]]) {
//            for (YXQAItem *subItem in ((YXQAComplexItem *)item).itemArray) {
//                YXQAAnswerState state = [subItem answerState];
//                if (state == YXAnswerStateCorrect) {
//                    correct++;
//                }else if (state == YXAnswerStateWrong){
//                    wrong++;
//                }else{
//                    unAnswer++;
//                }
//            }
//        }else{
//            YXQAAnswerState state = [item answerState];
//            if (state == YXAnswerStateCorrect) {
//                correct++;
//            }else if (state == YXAnswerStateWrong){
//                wrong++;
//            }else if (state == YXAnswerStateAnswered){
//                answered++;
//            }else{
//                unAnswer++;
//            }
//            if (item.templateType == YXQATemplateSubjective) {
//                subjectiveCount++;
//                YXQAItem *t = (YXQAItem *)item;
//                subjectiveScore += t.score.floatValue;
//            }
//        }
//    }
//    data.total = correct + wrong + unAnswer + answered;
//    data.corrected = correct;
//    data.answered = correct + wrong + answered;
//    data.subjectiveCount = subjectiveCount;
//    data.time = model.duration;
//    data.subjectiveTotalScore = subjectiveScore;
    return data;
}
@end

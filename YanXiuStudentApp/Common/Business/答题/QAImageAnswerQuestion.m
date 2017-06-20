//
//  QAImageAnswerQuestion.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAImageAnswerQuestion.h"

@implementation QAImageAnswer

@end

@implementation QAImageAnswerQuestion
- (NSArray *)correctAnswersWithRawData:(YXQuestion *)rawData{
    return rawData.answer;
}

- (NSMutableArray *)myAnswersWithRawData:(YXQuestion *)rawData{
    NSMutableArray *myAnswerArray = [NSMutableArray array];
    for (NSString *url in rawData.pad.jsonAnswer) {
        QAImageAnswer *answer = [self imageAnswerWithUrl:url];
        [myAnswerArray addObject:answer];
    }
    return myAnswerArray;
}

- (QAImageAnswer *)imageAnswerWithUrl:(NSString *)url{
    QAImageAnswer *answer = [[QAImageAnswer alloc]init];
    answer.url = url;
    return answer;
}

#pragma mark - 答题状态
- (YXQAAnswerState)answerState{
    if (self.isMarked) {
        NSInteger score = self.score;
        if (score == 0) {
            return YXAnswerStateWrong;
        }else if (score == kFullMarkScore){
            return YXAnswerStateCorrect;
        }else{
            return YXAnswerStateHalfCorrect;
        }
    }else{
        if ([self.myAnswers count] > 0) {
            return YXAnswerStateAnswered;
        }else{
            return YXAnswerStateNotAnswer;
        }
    }
}

#pragma mark - 答题报告
- (NSArray *)answerForReport{
    NSMutableArray *answerArray = [NSMutableArray array];
    [self.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAImageAnswer *answer = (QAImageAnswer *)obj;
        if (!isEmpty(answer.url)) {
            [answerArray addObject:answer.url];
        }
    }];
    return [NSArray arrayWithArray:answerArray];
}

#pragma mark - 答案本地保存
- (void)saveAnswer {
    NSString *key = [self questionKey];
    if (!key) {
        return;
    }
    [self removeImageFolder];
    [self createImageFolderIfNeeded];
    NSString *folderPath = [self imageFolderPath];
    NSMutableArray *pathArray = [NSMutableArray array];
    [self.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAImageAnswer *answer = (QAImageAnswer *)obj;
        UIImage *image = (UIImage *)answer.data;
        NSData *data = UIImagePNGRepresentation(image);
        NSString *path = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@(idx)]];
        [data writeToFile:path atomically:YES];
        [pathArray addObject:path];
    }];
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        NSData *data = [NSJSONSerialization dataWithJSONObject:pathArray options:0 error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:key inContext:localContext];
        if (!entity) {
            entity = [QuestionAnswerEntity MR_createEntityInContext:localContext];
            entity.questionKey = key;
        }
        entity.questionAnswer = str;
    }];
}

- (void)loadAnswer {
    NSString *key = [self questionKey];
    if (!key) {
        return;
    }
    QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:key];
    if (entity) {
        NSData *data = [entity.questionAnswer dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.myAnswers removeAllObjects];
        for (NSString *path in arr) {
            QAImageAnswer *answer = [[QAImageAnswer alloc]init];
            NSData *imageData = [[NSData alloc]initWithContentsOfFile:path];
            UIImage *image = [[UIImage alloc]initWithData:imageData];
            answer.data = image;
            [self.myAnswers addObject:answer];
        }
    }
}

- (void)clearAnswer {
    NSString *key = [self questionKey];
    if (!key) {
        return;
    }
    [self removeImageFolder];
    WEAK_SELF
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        STRONG_SELF
        QuestionAnswerEntity *entity = [QuestionAnswerEntity MR_findFirstByAttribute:@"questionKey" withValue:key inContext:localContext];
        if (entity) {
            [entity MR_deleteEntityInContext:localContext];
        }
    }];
}

- (void)createImageFolderIfNeeded {
    NSString *folderPath = [self imageFolderPath];
    BOOL isFolder;
    BOOL exist = [[NSFileManager defaultManager]fileExistsAtPath:folderPath isDirectory:&isFolder];
    if (!exist || !isFolder) {
        [[NSFileManager defaultManager]createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)removeImageFolder {
    NSString *folderPath = [self imageFolderPath];
    BOOL isFolder;
    BOOL exist = [[NSFileManager defaultManager]fileExistsAtPath:folderPath isDirectory:&isFolder];
    if (exist && isFolder) {
        [[NSFileManager defaultManager]removeItemAtPath:folderPath error:nil];
    }
}

- (NSString *)imageFolderPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *folderPath = [docDir stringByAppendingPathComponent:@"question_image_folder"];
    folderPath = [folderPath stringByAppendingPathComponent:[self questionKey]];
    return folderPath;
}

@end

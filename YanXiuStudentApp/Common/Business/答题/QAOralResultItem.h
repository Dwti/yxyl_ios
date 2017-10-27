//
//  QAOralResultItem.h
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, QAOralResultGrade) {
    QAOralResultGradeD,
    QAOralResultGradeC,
    QAOralResultGradeB,
    QAOralResultGradeA
};

@protocol QAOralResultItemWord<NSObject>
@end
@interface QAOralResultItemWord : JSONModel
@property (nonatomic, strong) NSString<Optional> *StressOfWord;
@property (nonatomic, strong) NSString<Optional> *begin;
@property (nonatomic, strong) NSString<Optional> *end;
@property (nonatomic, strong) NSString<Optional> *score;
@property (nonatomic, strong) NSString<Optional> *text;
@property (nonatomic, strong) NSString<Optional> *type;
@property (nonatomic, strong) NSString<Optional> *volume;
@end

@protocol QAOralResultItemLine<NSObject>
@end
@interface QAOralResultItemLine : JSONModel
@property (nonatomic, strong) NSString<Optional> *begin;
@property (nonatomic, strong) NSString<Optional> *end;
@property (nonatomic, strong) NSString<Optional> *fluency;
@property (nonatomic, strong) NSString<Optional> *integrity;
@property (nonatomic, strong) NSString<Optional> *pronunciation;
@property (nonatomic, strong) NSString<Optional> *sample;
@property (nonatomic, strong) NSString<Optional> *score;
@property (nonatomic, strong) NSString<Optional> *usertext;
@property (nonatomic, strong) NSArray<QAOralResultItemWord, Optional> *words;
@end

@interface QAOralResultItem : JSONModel
@property (nonatomic, strong) NSArray<QAOralResultItemLine, Optional> *lines;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *version;

- (QAOralResultGrade)oralResultGrade;
- (NSString *)oralGradeImageName;
@end

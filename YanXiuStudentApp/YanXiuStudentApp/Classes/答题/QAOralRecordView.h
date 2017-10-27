//
//  QAOralRecordView.h
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USCRecognizer.h"
#import "LePlayer.h"
#import "QAOralResultItem.h"

typedef NS_ENUM(NSUInteger, QAOralRecordViewState) {
    QAOralRecordViewStateDisabled,
    QAOralRecordViewStateNormal,
    QAOralRecordViewStateRecording,
    QAOralRecordViewStateRecorded
};

@interface QAOralRecordView : UIView
@property (nonatomic, assign) BOOL network;
@property (nonatomic, assign) QAOralRecordViewState recordViewState;
@property (nonatomic, strong) NSString *oralText;
@property (nonatomic, strong) USCRecognizer *recognizer;
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) QAOralResultItem *resultItem;
@property (nonatomic, copy) void (^stopAudioPlayerBlock)(void);
@property (nonatomic, copy) void (^showResultBlock)(QAOralResultItem *resultItem);

- (instancetype)initWithState:(QAOralRecordViewState)recordViewState;
@end

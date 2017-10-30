//
//  QAOralQuestionView.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralQuestionView.h"
#import "QAOralQuestionStemCell.h"
#import "QAOralRecordView.h"
#import "QAOralGradeCell.h"
#import "QAOralGuideView.h"
#import "QAOralAnswerQuestion.h"

@interface QAOralQuestionView ()
@property (nonatomic, assign) BOOL network;

@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) QAOralRecordView *oralRecordView;

@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, strong) NSURL *audioUrl;
@property (nonatomic, assign) BOOL hasPlayed;
@property (nonatomic, assign) int guardCount;
@end

@implementation QAOralQuestionView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAOralQuestionStemCell class] forCellReuseIdentifier:@"QAOralQuestionStemCell"];
    [self.tableView registerClass:[QAOralGradeCell class] forCellReuseIdentifier:@"QAOralGradeCell"];
    
    [self setupOralRecordView];
    [self setupReachability];
    [self setupObserver];
    if (self.data.questionType == YXQAItemOralRepeat || self.data.questionType == YXQAItemOralDialogue) {
        [self setupPlayer];
    }
}

- (void)setupOralRecordView {
    self.oralRecordView = [[QAOralRecordView alloc] init];
    self.oralRecordView.oralText = self.data.questionType == YXQAItemOralRead ? self.data.contentAnswer.firstObject :  self.data.correctAnswers.firstObject;
    WEAK_SELF
    self.oralRecordView.stopAudioPlayerBlock = ^{
        STRONG_SELF
        [self.player pause];
        self.player.state = PlayerView_State_Finished;
    };
    self.oralRecordView.showResultBlock = ^(QAOralResultItem *resultItem) {
        STRONG_SELF
        YXQAAnswerState fromState = [self.data answerState];
        QAOralAnswerQuestion *question = (QAOralAnswerQuestion *)self.data;
        question.oralResultItem = resultItem;
        if (fromState != [self.data answerState] && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:[self.data answerState]];
        }
        [self.data saveAnswer];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    };
    [self addSubview:self.oralRecordView];
    [self.oralRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-78);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(124);
    }];
    if (self.data.answerState != YXAnswerStateNotAnswer) {
        self.oralRecordView.recordViewState = QAOralRecordViewStateRecorded;
        QAOralAnswerQuestion *question = (QAOralAnswerQuestion *)self.data;
        self.oralRecordView.resultItem = question.oralResultItem;
    }
}

- (void)setupReachability {
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reach startNotifier];
    
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReachabilityChangedNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        Reachability *reach = [notification object];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            [self.window nyx_showToast:@"网络未连接，请检查后重试"];
            self.network = NO;
        }else {
            self.network = YES;
        }
        self.oralRecordView.network = self.network;
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [RACObserve(self.oralRecordView, recordViewState) subscribeNext:^(id x) {
        STRONG_SELF
        self.audioBtn.enabled = (QAOralRecordViewState)[x integerValue] != QAOralRecordViewStateRecording;
        
    }];
    [RACObserve(self.oralRecordView.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        self.audioBtn.enabled = (PlayerView_State)[x integerValue] != PlayerView_State_Buffering && (PlayerView_State)[x integerValue] != PlayerView_State_Playing;
    }];
}

- (void)setupPlayer {
    self.player = [[LePlayer alloc] init];
    WEAK_SELF
    [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        PlayerView_State state = (PlayerView_State)[x integerValue];
        if (state == PlayerView_State_Buffering || state == PlayerView_State_Playing) {
            [self.audioBtn.imageView startAnimating];
        } else if (state == PlayerView_State_Paused) {
            [self.audioBtn.imageView stopAnimating];
        } else if (state == PlayerView_State_Finished) {
            [self.audioBtn.imageView stopAnimating];
            if (!self.hasPlayed) {
                self.oralRecordView.recordViewState = QAOralRecordViewStateNormal;
                self.hasPlayed = YES;
            }
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"kHasShowedOralGuide"]) {
                [self showGuide];
            }
        }
    }];
}

- (void)audioBtnAction:(UIButton *)sender {
    if (!self.network) {
        [self.window nyx_showToast:@"网络未连接，请检查后重试"];
        return;
    }
    if (self.player.state == PlayerView_State_Playing) {
        return;
    }
    self.player.videoUrl = self.audioUrl;
}

- (void)setupFirstInState {
    if (self.guardCount++ != 1) {
        return;
    }
    if (self.data.answerState != YXAnswerStateNotAnswer) {
        self.oralRecordView.recordViewState = QAOralRecordViewStateRecorded;
        self.hasPlayed = YES;
    } else {
        self.oralRecordView.recordViewState = QAOralRecordViewStateDisabled;
        self.player.videoUrl = self.audioUrl;
    }
}

- (void)showGuide {
    AlertView *alert = [[AlertView alloc] init];
    alert.hideWhenMaskClicked = YES;
    QAOralGuideView *guideView = [[QAOralGuideView alloc] init];
    guideView.btnClickBlock = ^{
        [alert hide];
    };
    alert.contentView = guideView;
    [alert showWithLayout:^(AlertView *view) {
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-51.5f);
            make.size.mas_equalTo(CGSizeMake(215, 241));
        }];
    }];
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"kHasShowedOralGuide"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    [heightArray addObject:@([QAOralQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    [heightArray addObject:@(40)];
    [heightArray addObject:@(158)];
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
            self.headerCell = cell;
        }
        return cell;
    } else if (indexPath.row == 1) {
        QAOralQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAOralQuestionStemCell"];
        cell.bottomLineHidden = YES;
        cell.delegate = self;
        WEAK_SELF
        cell.audioBtnBlock = ^(UIButton *sender, NSURL *audioUrl) {
            STRONG_SELF
            if (![self.audioBtn isEqual:sender]) {
                self.audioBtn = sender;
                [self.audioBtn addTarget:self action:@selector(audioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (![self.audioUrl isEqual:audioUrl]) {
                self.audioUrl = audioUrl;
                [self setupFirstInState];
            }
        };
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    } else if (indexPath.row == 2) {
        QAOralGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAOralGradeCell"];
        QAOralAnswerQuestion *question = (QAOralAnswerQuestion *)self.data;
        cell.resultItem = question.oralResultItem;
        cell.hidden = isEmpty(question.oralResultItem);
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.hidden = YES;
        return cell;
    }
}

- (void)leaveForeground {
    [super leaveForeground];
    
    [self.player pause];
    self.player.state = PlayerView_State_Finished;
    [self.oralRecordView.player pause];
    self.oralRecordView.player.state = PlayerView_State_Finished;
    [self.oralRecordView.recognizer cancel];
    
    if (self.data.answerState == YXAnswerStateNotAnswer) {
        self.hasPlayed = NO;
    }

}

- (void)enterForeground {
    [super enterForeground];

    [self setupFirstInState];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"kHasShowedOralGuide"] && (self.oriData.questionType == YXQAItemOralRead || self.oriData.questionType == YXQAItemOralComposition)) {
        [self showGuide];
    }
}

@end

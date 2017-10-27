//
//  QAOralQuestionAnalysisView.m
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAOralQuestionAnalysisView.h"
#import "QAOralQuestionStemCell.h"
#import "LePlayer.h"

@interface QAOralQuestionAnalysisView ()
@property (nonatomic, strong) UIButton *audioBtn;
@property (nonatomic, strong) LePlayer *player;
@property (nonatomic, assign) BOOL network;
@property (nonatomic, strong) NSURL *audioUrl;
@end

@implementation QAOralQuestionAnalysisView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAOralQuestionStemCell class] forCellReuseIdentifier:@"QAOralQuestionStemCell"];
    [self setupReachability];
    if (self.data.questionType == YXQAItemOralRepeat || self.data.questionType == YXQAItemOralDialogue) {
        [self setupPlayer];
    }
}

- (void)setupPlayer {
    self.player = [[LePlayer alloc] init];
    WEAK_SELF
    [RACObserve(self.player, state) subscribeNext:^(id x) {
        STRONG_SELF
        PlayerView_State state = (PlayerView_State)[x integerValue];
        if (state == PlayerView_State_Buffering || state == PlayerView_State_Playing) {
            [self.audioBtn.imageView startAnimating];
        } else  {
            [self.audioBtn.imageView stopAnimating];
        }
    }];
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
            [self.player pause];
        }else {
            self.network = YES;
        }
    }];
}

- (void)audioBtnAction:(UIButton *)sender {
    if (!self.network) {
        [self.window nyx_showToast:@"网络未连接，请检查后重试"];
        return;
    }
    if (self.player.state == PlayerView_State_Buffering || self.player.state == PlayerView_State_Playing) {
        return;
    }
    self.player.videoUrl = self.audioUrl;
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAOralQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
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
    }else if (indexPath.row == 1) {
        if (self.hideQuestion) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        }
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
            }
        };
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)leaveForeground {
    [self.player pause];
    self.player.state = PlayerView_State_Finished;
}

@end

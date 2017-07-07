//
//  QASubjectiveStemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveStemCell.h"
#import "QACoreTextViewHandler.h"
#import "QASubjectiveStemBlankView.h"
#import "QACoreTextViewStringScanner.h"

@interface QASubjectiveStemCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSMutableArray<QASubjectiveStemBlankView *> *blankViewArray;
@end

@implementation QASubjectiveStemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.blankViewArray = [NSMutableArray array];
        self.scanner = [[QACoreTextViewStringScanner alloc]init];
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QASubjectiveStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QASubjectiveStemCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        for (UIView *v in self.blankViewArray) {
            [v removeFromSuperview];
        }
        [self.blankViewArray removeAllObjects];
        [self.scanner scanCoreTextView:self.htmlView string:@"------------" scanBlock:^(NSInteger index, NSInteger total, CGRect frame) {
            [self setupBlankViewWithIndex:index total:total frame:frame];
        }];
    }];
}

- (void)setupBlankViewWithIndex:(NSInteger)index total:(NSInteger)total frame:(CGRect)frame {
    QASubjectiveStemBlankView *view = [[QASubjectiveStemBlankView alloc]initWithFrame:frame];
    view.index = index+1;
    if (total == 1) {
        view.indexHidden = YES;
    }
    [self.htmlView addSubview:view];
    [self.blankViewArray addObject:view];
}

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub {
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    NSString *adjustedString = [QASubjectiveStemCell adjustedStringForString:string];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:adjustedString options:dic];
}

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub{
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = nil;
    if (isSub) {
        dic = [YXQACoreTextHelper defaultOptionsForLevel2];
    }else{
        dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    }
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:[QASubjectiveStemCell adjustedStringForString:string] options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

+ (NSString *)adjustedStringForString:(NSString *)string {
    NSString *adjustedString = [string stringByReplacingOccurrencesOfString:@"(_)" withString:@"------------"];
    return adjustedString;
}

@end

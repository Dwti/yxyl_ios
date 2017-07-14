//
//  QAClozeStemCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAClozeStemCell.h"
#import "QACoreTextViewStringScanner.h"
#import "QAClozeItemInfo.h"
#import "QAClozeBlankView.h"

@interface QAClozeStemCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSMutableArray<QAClozeItemInfo *> *blankItemArray;
@end

@implementation QAClozeStemCell

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30-5;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string {
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = [YXQACoreTextHelper optionsForClozeStem];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

- (UIView *)currentBlankView {
    return self.blankItemArray[self.currentIndex].coverView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.blankItemArray = [NSMutableArray array];
        self.placeholder = @"------------";
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
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAClozeStemCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAClozeStemCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        [self.blankItemArray enumerateObjectsUsingBlock:^(QAClozeItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.scanner scanCoreTextView:self.htmlView stringRange:obj.blankRange resultBlock:^(NSArray *frameArray) {
                [self setupViewsForBlankIndex:idx frames:frameArray];
            }];
        }];
        
        [self.selectItemDelegate layoutRefreshed];
    }];
}

- (void)setupViewsForBlankIndex:(NSInteger)index frames:(NSArray *)frameArray {
    QAClozeItemInfo *info = self.blankItemArray[index];
    [info.coverView removeFromSuperview];
    NSValue *value = frameArray.firstObject;
    CGRect rect = value.CGRectValue;
    QAClozeBlankView *view = [[QAClozeBlankView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+2)];
    QAQuestion *question = self.question.childQuestions[index];
    NSArray *arr = [question.position.indexString componentsSeparatedByString:@"/"];
    NSString *indexStr = [arr.firstObject yx_stringByTrimmingCharacters];
    [view updateWithIndex:indexStr.integerValue answer:[self answerForIndex:index]];
    WEAK_SELF
    [view setClickAction:^{
        STRONG_SELF
        self.currentIndex = index;        
        [self.selectItemDelegate didSelectItemAtIndex:index];
    }];
    
    BOOL isCurrent = index==self.currentIndex;
    if (self.isAnalysis) {
        QAQuestion *q = self.question.childQuestions[index];
        [view updateWithState:[q answerState] current:isCurrent];
    }
    
    [self.htmlView addSubview:view];
    info.coverView = view;
    
    if (isCurrent && !self.isAnalysis) {
        [view enterAnimated:NO];
    }
}

- (NSString *)answerForIndex:(NSInteger)index {
    QAQuestion *subQ = self.question.childQuestions[index];
    __block NSInteger answerIndex = -1;
    [subQ.myAnswers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *n = (NSNumber *)obj;
        if (n.boolValue) {
            answerIndex = idx;
            *stop = YES;
        }
    }];
    
    if (answerIndex >= 0) {
        return subQ.options[answerIndex];
    }
    return nil;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex == self.currentIndex) {
        return;
    }
    if (self.isAnalysis) {
        _currentIndex = currentIndex;
        [self refresh];
        return;
    }
    QAClozeItemInfo *preInfo = self.blankItemArray[self.currentIndex];
    QAClozeBlankView *preView = (QAClozeBlankView *)preInfo.coverView;
    [preView leave];
    
    _currentIndex = currentIndex;
    QAClozeItemInfo *curInfo = self.blankItemArray[self.currentIndex];
    QAClozeBlankView *curView = (QAClozeBlankView *)curInfo.coverView;
    [curView enter];
}

- (void)setQuestion:(QAQuestion *)question {
    _question = question;
    [self refresh];
}

- (void)refresh {
    NSAttributedString *attrString = [self attrStringForString:self.question.stem];
    NSString *plainString = [attrString plainTextString];
    
    NSRegularExpression *reg = [self regForBlank];
    NSArray<NSTextCheckingResult *> *results = [reg matchesInString:plainString options:NSMatchingReportCompletion range:NSMakeRange(0, plainString.length)];
    
    for (QAClozeItemInfo *info in self.blankItemArray) {
        [info.coverView removeFromSuperview];
    }
    [self.blankItemArray removeAllObjects];
    __block NSInteger locationOffset = 0;
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAClozeItemInfo *info = [[QAClozeItemInfo alloc]init];
        info.placeholder = [self placeholderForBlankIndex:idx];
        NSRange blankRange = NSMakeRange(obj.range.location+locationOffset, info.placeholder.length);
        info.blankRange = blankRange;
        [self.blankItemArray addObject:info];
        locationOffset += (info.placeholder.length-obj.range.length);
    }];
    
    NSString *finalStem = self.question.stem;
    NSTextCheckingResult *result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
    NSInteger index = 0;
    while (result) {
        QAClozeItemInfo *info = self.blankItemArray[index];
        NSString *template = info.placeholder;
        
        NSRange range = result.range;
        finalStem = [reg stringByReplacingMatchesInString:finalStem
                                                  options:NSMatchingReportCompletion
                                                    range:range
                                             withTemplate:template];
        result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
        index++;
    }
    
    self.htmlView.attributedString = [self attrStringForString:finalStem];
}

- (NSAttributedString *)attrStringForString:(NSString *)string {
    NSDictionary *dic = [YXQACoreTextHelper optionsForClozeStem];
    return [YXQACoreTextHelper attributedStringWithString:string options:dic];
}

- (NSRegularExpression *)regForBlank {
    NSString *pattern = @"\\(_\\)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return reg;
}

- (NSString *)placeholderForBlankIndex:(NSInteger)index {
    NSString *placeholder = self.placeholder;
    NSString *answer = [self answerForIndex:index];
    if (!isEmpty(answer)) {
        NSString *space = @"-";
        NSDictionary *attrDic = @{NSFontAttributeName:[UIFont fontWithName:YXFontArialNarrow size:17]};
        CGSize spaceSize = [space sizeWithAttributes:attrDic];
        CGFloat spaceWidth = ceilf(spaceSize.width);
        
        CGSize size = [answer sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:YXFontArialNarrow_Bold size:17]}];
        if (self.isAnalysis && index == self.currentIndex) {
            size.width += 10;
        }
        CGFloat width = MIN(size.width+21, [QAClozeStemCell maxContentWidth]);
        NSInteger spaceNum = ceil(width/spaceWidth);
        NSString *s = @"";
        for (NSInteger i = 0; i < spaceNum; i++) {
            s = [s stringByAppendingString:@"-"];
        }
        placeholder = s;
    }
    return placeholder;
}

@end

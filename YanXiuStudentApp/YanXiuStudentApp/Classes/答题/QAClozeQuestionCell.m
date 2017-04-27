//
//  QAClozeQuestionCell.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAClozeQuestionCell.h"
#import "QACoreTextViewStringScanner.h"

@interface QAClozeQuestionCell()

@property (nonatomic, strong) NSString *adjustString;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *placeholderViewArray;

@end


@implementation QAClozeQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.left.mas_equalTo(17);
        make.bottom.mas_equalTo(-17);
        make.right.mas_equalTo(-17);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAClozeQuestionCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height) {
        STRONG_SELF
        CGFloat totalHeight = [QAClozeQuestionCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    
    self.scanner = [[QACoreTextViewStringScanner alloc] init];
}

- (void)setupButtons {
    self.buttonArray = [[NSMutableArray alloc] init];
    
    NSString *pattern2 = @"________";
    NSRegularExpression *reg2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:nil];
    NSArray* match = [reg2 matchesInString:self.adjustString options:NSMatchingReportCompletion range:NSMakeRange(0, [self.adjustString length])];
    
    if (match.count != 0) {
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *matc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >= self.qaData.childQuestions.count) {
                return;
            }
            
            QAQuestion *item = self.qaData.childQuestions[idx];
            NSString *title = [self itemPositon:item];
            UIButton *button = [UIButton new];
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"未选择"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"当前选择"] forState:UIControlStateDisabled];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateDisabled];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.tag = idx;

            if (self.isAnalysis) {
                if ([item answerState] == YXAnswerStateCorrect) {
                    [button setTitleColor:[UIColor colorWithRGBHex:0x00cccc] forState:UIControlStateNormal];
                } else {
                    [button setTitleColor:[UIColor colorWithRGBHex:0xff80aa] forState:UIControlStateNormal];
                }
            } else {
                [button setTitleColor:[UIColor colorWithRGBHex:0x805500] forState:UIControlStateNormal];
            }
            
            WEAK_SELF
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG_SELF
                self.selectedButton = button;
                [self.selectItemDelegate didSelectItemAtIndex:idx];
            }];
            
            [self.buttonArray addObject:button];
            [self selectAnswerWithQuestion:idx];
        }];
        self.selectedButton = self.buttonArray[self.currentIndex];
    }    
}

- (void)selectAnswerWithQuestion:(NSInteger)question {
    NSArray *answers = [self.qaData.childQuestions[question] myAnswers];
    [answers enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *item = self.qaData.childQuestions[question];
        if (value.boolValue) {
            *stop = YES;
            char c = 'A' + idx;
            NSString *title = [NSString stringWithFormat:@"%@.%c", [self itemPositon:item], c];
            UIButton *button = self.buttonArray[question];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateDisabled];
            [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"已完成"] forState:UIControlStateNormal];
        }
        
        if (!*stop && idx == answers.count - 1) {
            NSString *title = [self itemPositon:item];
            UIButton *button = self.buttonArray[question];
            [button setBackgroundImage:[UIImage yx_resizableImageNamed:@"未选择"] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateDisabled];
        }
    }];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        [self.scanner scanCoreTextView:self.htmlView string:@"________" scanBlock:^(NSInteger index, NSInteger total, CGRect frame) {
            if (!self.placeholderViewArray) {
                self.placeholderViewArray = [NSMutableArray array];
                for (int i=0; i<total; i++) {
                    UIButton *b = self.buttonArray[i];
                    [self.placeholderViewArray addObject: b];
                }
            }
            CGRect rect =  CGRectMake(floorf(frame.origin.x), floorf(frame.origin.y)-2, ceilf(frame.size.width+1), ceilf(frame.size.height+1)+3);
            UIView *v = self.placeholderViewArray[index];
            v.frame = rect;
            [self.htmlView addSubview:v];
        }];
        [self.selectItemDelegate layoutRefreshed];
    }];
}

- (void)setQaData:(QAQuestion *)qaData {
    _qaData = qaData;
    
    self.adjustString = [QAQuestionUtil stringByReplacingUnderlineInsideParentheses:qaData.stem template:@" ________ "];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:self.adjustString];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    [self setupButtons];
    [self setupObserver];
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    _selectedButton.enabled = YES;
    _selectedButton = selectedButton;
    _selectedButton.enabled = NO;
}

- (NSString *)itemPositon:(QAQuestion *)item {
    return [[item.position.indexDetailString componentsSeparatedByString:@"/"] objectAtIndex:0];
}

+ (CGFloat)maxContentWidth {
    return [UIScreen mainScreen].bounds.size.width - 10 - 17 - 60 - 20 - 30 - 4;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height {
    CGFloat h = 17 + height + 17;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string {
    CGFloat maxWidth = [QAClozeQuestionCell maxContentWidth];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string constraintedToWidth:maxWidth];
    CGFloat height = [QAClozeQuestionCell totalHeightWithContentHeight:stringHeight];
    return height;
}

@end

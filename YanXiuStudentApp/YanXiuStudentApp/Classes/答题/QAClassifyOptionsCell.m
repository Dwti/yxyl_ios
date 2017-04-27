//
//  QAClassifyOptionsCell.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyOptionsCell.h"
#import "YXQADashLineView.h"

@interface QAClassifyOptionsCell()

@property (nonatomic, strong) YXQADashLineView *line;

@end

@implementation QAClassifyOptionsCell

+ (CGFloat)heightForItem:(NSMutableArray *)datas{
    if (isEmpty(datas)) {
        return 0.1f;
    }
    
    OptionsDataType type = OptionsStringDataType;
    
    NSString *orgString = datas.firstObject;
    NSString *pattern = @"<p>";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSString *result = [reg stringByReplacingMatchesInString:orgString
                                                     options:NSMatchingReportCompletion
                                                       range:NSMakeRange(0, orgString.length)
                                                withTemplate:@""];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([result hasPrefix:@"<img src="]) {
        type = OptionsImageDataType;
    }
    
    OptionsView *view = [[OptionsView alloc] initWithDataType:type];
    view.datas = datas;
    return view.estimatedHeight;
}

#pragma mark- Delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    [self.delegate tableViewCell:cell updateWithHeight:height];
}

#pragma mark- Set
- (void)setDatas:(NSMutableArray *)datas{
    self.optionsView.datas = datas;
    [self tableViewCell:self updateWithHeight:self.optionsView.estimatedHeight];
}

- (void)setOptionsView:(OptionsView *)optionsView{
    [_optionsView removeFromSuperview];
    _optionsView = optionsView;
    [self addSubview:_optionsView];
    [_optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0).priorityHigh();
    }];
}

#pragma mark-
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.line = [YXQADashLineView new];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-10);
            make.top.offset = 25;
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  QAConnectContentCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectContentCell.h"
#import "QAConnectItemView.h"
#import "QAConnectOptionInfo.h"

static const CGFloat kFixHeight = 20.f;

@interface QAConnectContentCell()<YXHtmlCellHeightDelegate>
@property (nonatomic, strong) QAConnectItemView *itemView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) HeightChangeBlock block;
@end


@implementation QAConnectContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.itemView.isSelected = YES;
    }else {
        self.itemView.isSelected = NO;
    }
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.itemView = [[QAConnectItemView alloc]init];
    self.itemView.isSelected = NO;
    self.itemView.delegate = self;
    self.itemView.maxContentWidth = [self maxContentWidth];
    [self addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
}

- (void)setOptionInfo:(QAConnectOptionInfo *)optionInfo {
    _optionInfo = optionInfo;
    self.itemView.content = optionInfo.option;
}

- (CGSize)defaultSize {
    return CGSizeMake([self maxContentWidth], [self heightForString:self.optionInfo.option]);
}

- (CGFloat)maxContentWidth {
    return (SCREEN_WIDTH - 70 - 55)/2 - 30;
}

- (CGFloat)heightForString:(NSString *)string {
    return [QAConnectItemView heightForString:string width:[self maxContentWidth]] + kFixHeight;
}

- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    BLOCK_EXEC(self.block,height + kFixHeight);
}

-(void)setHeightChangeBlock:(HeightChangeBlock)block {
    self.block = block;
}
@end

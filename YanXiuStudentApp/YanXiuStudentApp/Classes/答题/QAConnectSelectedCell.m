//
//  QAConnectSelectedCell.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAConnectSelectedCell.h"
#import "QAConnectOptionInfo.h"

static const CGFloat kMinHeight = 45.f;
static const CGFloat kFixHeight = 45.f;


@interface QAConnectSelectedCell()<YXHtmlCellHeightDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *rightLineView;

@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, copy) DeleteOptionActionBlock deleteActionBlock;
@property (nonatomic, strong) QAConnectTwinOptionInfo *twinOption;
@property (nonatomic, copy) CellHeightChangeBlock block;
@end


@implementation QAConnectSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
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
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.containerView.layer.cornerRadius = 6.f;
    self.containerView.clipsToBounds = YES;
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15.f);
    }];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.containerView addSubview:self.deleteButton];
    [self.deleteButton setImage:[UIImage imageNamed:@"连线题连接内容删掉按钮"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"连线连接内容删掉按钮点击态"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    self.leftLineView = [[UIView alloc]init];
    self.leftLineView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.leftLineView];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left);
        make.centerY.equalTo(self.deleteButton);
        make.width.mas_equalTo(17.f);
        make.height.mas_equalTo(2.f);
    }];
    
    self.rightLineView = [[UIView alloc]init];
    self.rightLineView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.rightLineView];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right);
        make.centerY.equalTo(self.deleteButton);
        make.width.mas_equalTo(17.f);
        make.height.mas_equalTo(2.f);
    }];
    
    self.leftView = [[QAConnectItemView alloc]init];
    self.leftView.maxContentWidth = [QAConnectSelectedCell maxContentWidth];
    self.leftView.delegate = self;
    [self.containerView addSubview:self.leftView];
    
    self.rightView = [[QAConnectItemView alloc]init];
    self.rightView.maxContentWidth = [QAConnectSelectedCell maxContentWidth];
    self.rightView.delegate = self;
    [self.containerView addSubview:self.rightView];
}

- (void)deleteAction:(UIButton *)sender {
    self.currentHeight = 0;
    BLOCK_EXEC(self.deleteActionBlock,self.twinOption);
}

+ (CGFloat)itemHeightWithHeight:(CGFloat)height{
    return MAX(height, kMinHeight);
}

+ (CGFloat)itemWidth{
    return (SCREEN_WIDTH - 70 - 55)/2;
}

+ (CGFloat)maxContentWidth{
    return [self itemWidth] - 30;
}

- (void)updateWithTwinOption:(QAConnectTwinOptionInfo *)twinOption {
    self.twinOption = twinOption;
    [self updateWithLeftContent:twinOption.leftOptionInfo.option rightContent:twinOption.rightOptionInfo.option];
}

- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [QAConnectSelectedCell maxContentWidth];
    CGFloat l = [QAConnectItemView heightForString:left width:width];
    CGFloat r = [QAConnectItemView heightForString:right width:width];
    CGFloat ll = [QAConnectSelectedCell itemHeightWithHeight:l];
    CGFloat rr = [QAConnectSelectedCell itemHeightWithHeight:r];
    self.currentHeight = MAX(ll, rr);
    self.leftView.content = left;
    self.rightView.content = right;
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([QAConnectSelectedCell itemWidth], ll));
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([QAConnectSelectedCell itemWidth], rr));
    }];
}

+ (CGFloat)heightForTwinOption:(QAConnectTwinOptionInfo *)twinOption {
    return [self heightForLeftContent:twinOption.leftOptionInfo.option rightContent:twinOption.rightOptionInfo.option] + kFixHeight;
}

+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right{
    CGFloat width = [self maxContentWidth];
    CGFloat l = [QAConnectItemView heightForString:left width:width];
    CGFloat r = [QAConnectItemView heightForString:right width:width];
    CGFloat ll = [QAConnectSelectedCell itemHeightWithHeight:l];
    CGFloat rr = [QAConnectSelectedCell itemHeightWithHeight:r];
    return MAX(ll, rr);
}

- (void)setCellHeightChangeBlock:(CellHeightChangeBlock)block {
    self.block = block;
}

- (void)setDeleteOptionActionBlock:(DeleteOptionActionBlock)block {
    self.deleteActionBlock = block;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    CGFloat h = [QAConnectSelectedCell itemHeightWithHeight:height];
    if ((UIView *)cell == self.leftView) {
        [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake([QAConnectSelectedCell itemWidth], h));
        }];
    }else if ((UIView *)cell == self.rightView){
        [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake([QAConnectSelectedCell itemWidth], h));
        }];
    }
    if (h > self.currentHeight) {
        self.currentHeight = h;
        BLOCK_EXEC(self.block,h + kFixHeight);
    }
}
@end

//
//  YXErrorTableViewCell.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXErrorTableViewCell.h"

#define MAXWIDTH ([UIScreen mainScreen].bounds.size.width - 30)

static const CGFloat kMaxContentHeight = 200;

@interface YXErrorTableViewCell()
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@end

@implementation YXErrorTableViewCell
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
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.typeLabel = [[UILabel alloc]init];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [topView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"我的错题删除当前错题icon正常态"] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"我的错题删除当前错题icon点击态"] forState:UIControlStateHighlighted];
    [self.deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    UIView *seperatorLineView = [[UIView alloc]init];
    seperatorLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self.contentView addSubview:seperatorLineView];
    [seperatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    bottomView.layer.shadowRadius = 1;
    bottomView.layer.shadowOpacity = 0.02;
    bottomView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(seperatorLineView.mas_bottom);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    self.htmlView.clipsToBounds = YES;
    [bottomView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:MAXWIDTH];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [YXErrorTableViewCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
}

- (void)deleteAction {
    SAFE_CALL_OneParam(self.delegate, deleteItem, self.item);
}

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    _item = item;
    self.typeLabel.text = item.typeString;
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:[item stemForMistake] options:dic];
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height {
    CGFloat h = MIN(height, kMaxContentHeight);
    h = h + 40 + 50 + 1 + 10;
    return ceilf(h);
}

+ (CGFloat)heightForString:(NSString *)string{
    if (isEmpty(string)) {
        return 0.f;
    }
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:MAXWIDTH];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

@end

//
//  YXKnpCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXKnpCell.h"
#import "YXQADashLineView.h"

@interface YXKnpCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) YXKnowledgePointView *knpView;
@end

@implementation YXKnpCell


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

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    YXQADashLineView *dashView = [[YXQADashLineView alloc]init];
    [self.contentView addSubview:dashView];
    [dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(32, 18));
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    self.promptLabel.text = @"点击知识点，可以去加强练习哦^_^";
    self.promptLabel.font = [UIFont systemFontOfSize:11];
    self.promptLabel.textColor = [UIColor colorWithHexString:@"b3ab8f"];
    [self.contentView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(15);
        make.bottom.mas_equalTo(self.typeImageView.mas_bottom);
        make.right.mas_equalTo(-20);
    }];
    
    self.knpView = [[YXKnowledgePointView alloc]init];
    self.knpView.backgroundColor = [UIColor clearColor];
    self.knpView.delegate = self.delegate;
    [self.contentView addSubview:self.knpView];
}

- (void)setDelegate:(id<YXKnowledgePointViewDelegate>)delegate{
    self.knpView.delegate = delegate;
}

- (void)setItem:(YXQAAnalysisItem *)item{
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

- (void)setKnpArray:(NSArray *)knpArray{
    _knpArray = knpArray;
    NSMutableArray *array = [NSMutableArray array];
    for (QAKnowledgePoint *p in knpArray) {
        [array addObject:p.name];
    }
    self.knpView.pointArray = [NSArray arrayWithArray:array];
    CGFloat height = [YXKnowledgePointView heightWithPoints:array viewWidth:[UIScreen mainScreen].bounds.size.width-10-17-20*2];
    self.knpView.frame = CGRectMake(39, 30+18+15, [UIScreen mainScreen].bounds.size.width-10-17-20*2, height);
}

- (void)setKnpClickable:(BOOL)knpClickable{
    _knpClickable = knpClickable;
    self.promptLabel.hidden = !knpClickable;
    self.knpView.userInteractionEnabled = knpClickable;
}
+ (CGFloat)heightForPoints:(NSArray *)pointArray{
    NSMutableArray *array = [NSMutableArray array];
    for (QAKnowledgePoint *p in pointArray) {
        [array addObject:p.name];
    }
    CGFloat height = [YXKnowledgePointView heightWithPoints:array viewWidth:[UIScreen mainScreen].bounds.size.width-10-17-20*2];
    return 30 + 18 + 15 + height + 10;
    
}

@end

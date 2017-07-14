//
//  YXConnectContentCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXConnectContentCell.h"
#import "YXQAConnectGroupView.h"
#import "YXQAConnectStateManager.h"
#import "YXQAConnectLineView.h"

@interface YXQAGroupItem : NSObject
@property (nonatomic, strong) YXQAConnectGroupView *view;
@property (nonatomic, assign) CGFloat height;
@end
@implementation YXQAGroupItem
@end

@interface YXConnectContentCell()<YXHtmlCellHeightDelegate>

@property (nonatomic, strong) YXQAConnectStateManager *stateManager;
@property (nonatomic, strong) YXQAConnectLineView *connectLineView;

@end

@implementation YXConnectContentCell

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

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setItem:(QAQuestion *)item{
    if (self.item) {
        return;
    }
    _item = item;
    
    self.stateManager = [[YXQAConnectStateManager alloc]init];
    self.stateManager.item = item;
    
    if (self.groupArray) {
        [self setupGroups];
    }else{
        self.groupArray = [NSMutableArray array];
        NSInteger groupCount = item.options.count/2;
        for (int i = 0; i < groupCount; i++) {
            NSString *l = item.options[i];
            NSString *r = item.options[i+groupCount];
            CGFloat height = [YXQAConnectGroupView heightForLeftContent:l rightContent:r];
            YXQAConnectGroupView *v = [[YXQAConnectGroupView alloc]init];
            [v updateWithLeftContent:l rightContent:r];
            YXQAGroupItem *group = [[YXQAGroupItem alloc]init];
            group.view = v;
            group.height = height;
            [self.groupArray addObject:group];
        }
        [self setupGroups];
    }

    
    [self.stateManager setup];
    WEAK_SELF
    self.stateManager.refreshBlock = ^{
        STRONG_SELF
        [self refreshConnectLineView];
        [self executeRedoStatusDelegate];
    };
    
    self.connectLineView = [[YXQAConnectLineView alloc]init];
    self.connectLineView.item = self.item;
    [self.contentView addSubview:self.connectLineView];
    [self.connectLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    [self refreshConnectLineView];
}

- (void)executeRedoStatusDelegate {
    if (self.redoStatusDelegate && [self.redoStatusDelegate respondsToSelector:@selector(updateRedoStatus)]) {
        [self.redoStatusDelegate updateRedoStatus];
    }
}

- (void)setupGroups{
    NSMutableArray *leftArray = [NSMutableArray array];
    NSMutableArray *rightArray = [NSMutableArray array];
    [self.groupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXQAGroupItem *item = (YXQAGroupItem *)obj;
        item.view.delegate = self;
        [self.contentView addSubview:item.view];
        if (idx == 0) {
            [item.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(item.height);
            }];
        }else{
            YXQAGroupItem *group = self.groupArray[idx-1];
            [item.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(group.view.mas_left);
                make.right.mas_equalTo(group.view.mas_right);
                make.top.mas_equalTo(group.view.mas_bottom).mas_offset(20);
                make.height.mas_equalTo(item.height);
            }];
        }
        
        [leftArray addObject:item.view.leftView];
        [rightArray addObject:item.view.rightView];
    }];
    [self.stateManager.itemArray removeAllObjects];
    [self.stateManager.itemArray addObjectsFromArray:leftArray];
    [self.stateManager.itemArray addObjectsFromArray:rightArray];
}

- (void)refreshConnectLineView{
    CGFloat height = 0.f;
    NSMutableArray *positionArray = [NSMutableArray array];
    for (YXQAGroupItem *group in self.groupArray) {
        YXQAConnectPosition *p = [[YXQAConnectPosition alloc]init];
        p.position = group.height/2 + height;
        [positionArray addObject:p];
        height += group.height+20;
    }
    self.connectLineView.positionArray = positionArray;
    [self.connectLineView setNeedsDisplay];
}

+ (CGFloat)heightForItem:(QAQuestion *)item{
    CGFloat totalHeight = 0.f;
    NSInteger groupCount = item.options.count/2;
    for (int i = 0; i < groupCount; i++) {
        NSString *l = item.options[i];
        NSString *r = item.options[i+groupCount];
        CGFloat height = [YXQAConnectGroupView heightForLeftContent:l rightContent:r];
        totalHeight += height+20;
    }
    return totalHeight;
}

#pragma mark - for 解析
- (void)setShowAnalysisAnswers:(BOOL)showAnalysisAnswers{
    _showAnalysisAnswers = showAnalysisAnswers;
    self.connectLineView.showAnalysisAnswers = showAnalysisAnswers;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height{
    NSInteger index = 0;
    YXQAGroupItem *group = nil;
    for (int i=0; i<self.groupArray.count; i++) {
        YXQAGroupItem *item = self.groupArray[i];
        if (item.view == (UIView *)cell) {
            index = i;
            group = item;
            break;
        }
    }
    group.height = height;
    [self refreshConnectLineView];
    if (index == 0) {
        [group.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(group.height);
        }];
    }else{
        YXQAGroupItem *preGroup = self.groupArray[index-1];
        [group.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(preGroup.view.mas_left);
            make.right.mas_equalTo(preGroup.view.mas_right);
            make.top.mas_equalTo(preGroup.view.mas_bottom).mas_offset(20);
            make.height.mas_equalTo(group.height);
        }];
    }
    CGFloat totalHeight = 0.f;
    for (YXQAGroupItem *item in self.groupArray) {
        totalHeight += item.height+20;
    }
    [self.delegate tableViewCell:self updateWithHeight:totalHeight];
}

@end

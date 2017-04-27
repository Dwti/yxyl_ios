//
//  YXQAClassifyView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/5.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyQuestionView.h"
#import "YXClassesView.h"
#import "QATitleView.h"
#import "YXQADashLineView.h"
#import "UIButton+WebCache.h"
#import "DTAttributedTextContentView.h"
#import "YXClassesQuestionCell.h"
#import "OptionsView.h"
#import "OptionsImageView.h"
#import "OptionsStringView.h"
#import "QAClassifyManager.h"
#import "QAClassifyAnswersView.h"
#import "QAClassifyClassesCell.h"
#import "QAClassifyOptionsCell.h"

static NSString *titleTableViewCell = @"titleTableViewCell";
static NSString *classesTableViewCell = @"classesTableViewCell";
static NSString *optionsTableViewCell = @"optionTableViewCell";
static NSString *questionTableViewCell = @"questionTableViewCell";

@interface QAClassifyQuestionView()

@property (nonatomic, strong) OptionsView *optionsView;
@property (nonatomic, strong) YXClassesView *classesView;
@property (nonatomic, strong) QAClassifyManager *classifyManager;
@property (nonatomic, strong) QAClassifyAnswersView *answersView;
@property (nonatomic, strong) QAClassifyOptionsCell *optionsCell;

@end

@implementation QAClassifyQuestionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.classifyManager = [QAClassifyManager new];
    }
    return self;
}

#pragma mark-
- (void)setupUI{
    
    [super setupUI];
    
    self.optionsView = [[OptionsView alloc] initWithDataType:self.classifyManager.type];
    
    [self.tableView registerClass:[QAClassifyClassesCell class] forCellReuseIdentifier:classesTableViewCell];
    [self.tableView registerClass:[QAClassifyOptionsCell class] forCellReuseIdentifier:optionsTableViewCell];
    [self.tableView registerClass:[YXClassesQuestionCell class] forCellReuseIdentifier:questionTableViewCell];
    
    self.classesView = [YXClassesView new];
    self.classesView.backgroundColor = [UIColor clearColor];
    
    self.answersView = [QAClassifyAnswersView new];
    
    self.optionsCell = [[QAClassifyOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:optionsTableViewCell];
    self.optionsCell.delegate = self;
    self.optionsCell.optionsView = self.optionsView;
    
    self.answersView.type = self.classifyManager.type;
    self.classifyManager.classesView = self.classesView;
    self.classifyManager.optionsCell = self.optionsCell;
    self.classifyManager.answersView = self.answersView;
    WEAK_SELF
    [self.classifyManager setOptionChangeBlock:^{
        STRONG_SELF
        [self.cellHeightArray replaceObjectAtIndex:2 withObject:@([QAClassifyOptionsCell heightForItem:self.classifyManager.options])];
        [self.tableView reloadData];
    }];
}

#pragma mark- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row == 0){
        YXClassesQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:questionTableViewCell];
        cell.delegate = self;
        cell.question = self.data.stem;
        return cell;
    }else if (row == 1){
        QAClassifyClassesCell *cell = [tableView dequeueReusableCellWithIdentifier:classesTableViewCell];
        [cell addSubview:self.classesView];
        self.classesView.item = self.data;
        [self.classesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 14;
            make.right.offset = -14;
            make.top.offset = 35;
            make.height.offset = [YXClassesView heightForItem:self.data];
        }];
        return cell;
    }else if (row == 2){
        self.optionsCell.datas = self.classifyManager.options;
        return self.optionsCell;
    }
    return nil;
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXClassesQuestionCell heightForString:self.data.stem])];
    [heightArray addObject:@([YXClassesView heightForItem:self.data] + 35)];
    [heightArray addObject:@([QAClassifyOptionsCell heightForItem:self.classifyManager.options])];
    return heightArray;
}

- (void)setData:(QAQuestion *)data{
    [super setData:data];
    self.classifyManager.data = data;
    [self.tableView reloadData];
}

@end


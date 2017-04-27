//
//  YXChooseEditionView.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/4/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXExerciseChooseEdition_SubjectEditionListedView.h"
#import "YXDashLineCell.h"

@interface YXExerciseChooseEdition_SubjectEditionListedView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) GetEditionRequestItem_edition *edition;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *subjectButton;
@property (nonatomic, strong) UIImageView *subjectIcon;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YXExerciseChooseEdition_SubjectEditionListedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupUI];
//        [self _setupMock];
        _gapToCalculateHeight = MAXFLOAT;
    }
    return self;
}

- (void)_setupUI {
    self.clipsToBounds = NO;

    UIImage *bgImage = [[UIImage imageNamed:@"选择教材弹出背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 60, 60)];
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.image = bgImage;
    [self addSubview:self.backgroundImageView];
    self.backgroundImageView.frame = self.bounds;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    self.subjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subjectButton setBackgroundImage:[UIImage imageNamed:@"选择学科"] forState:UIControlStateNormal];
    [self.subjectButton setBackgroundImage:[UIImage imageNamed:@"选择学科-按下"] forState:UIControlStateHighlighted];
    [self addSubview:self.subjectButton];
    self.subjectButton.frame = CGRectMake(2.5, 2.5, self.width-5, 83);
    self.subjectButton.userInteractionEnabled = NO;
    
    self.subjectIcon = [[UIImageView alloc] init];
    [self addSubview:self.subjectIcon];
    self.subjectIcon.frame = CGRectMake((self.width-54)/2, -15, 54, 54);
    
    self.subjectLabel = [[UILabel alloc] init];
    self.subjectLabel.font = [UIFont boldSystemFontOfSize:20];
    self.subjectLabel.textColor = [UIColor colorWithHexString:@"805500"];
    self.subjectLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.subjectLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.subjectLabel.layer.shadowOpacity = 1;
    self.subjectLabel.layer.shadowRadius = 0;
    self.subjectLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.subjectLabel];
    self.subjectLabel.frame = CGRectMake(0, 45, self.width, 24);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"data"];
    [self.tableView registerClass:[YXDashLineCell class] forCellReuseIdentifier:@"dash"];
    [self addSubview:self.tableView];
    self.tableView.frame = CGRectMake(5, 86, self.width-10, self.height-86-5);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

#pragma mark - public API
- (void)setSubject:(GetSubjectRequestItem_subject *)subject{
    _subject = subject;
    self.subjectLabel.text = subject.name;
    self.subjectIcon.image = [UIImage imageNamed:[YXSubjectImageHelper smartExerciseImageNameWithType:[subject.subjectID integerValue]]];
}

- (void)setEditionItem:(GetEditionRequestItem *)editionItem{
    _editionItem = editionItem;
    [self.tableView reloadData];
    
    CGFloat tableViewHeight = (45 + 2) * [self.editionItem.editions count] - 2;
    
    for (int i = 1; i <= [self.editionItem.editions count]; i++) {
        tableViewHeight = (45 + 2) * i - 2;
        
        CGFloat gap = self.gapToCalculateHeight;
        if (self.gapToCalculateHeight == MAXFLOAT) {
            gap = 90; // iphone magical number
        }
        if (tableViewHeight > ([UIScreen mainScreen].bounds.size.height - 64 - gap - 86)) {
            tableViewHeight -= 70;
            break;
        }
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = self.frame;
                         rect.size.height = 86 + tableViewHeight + 5;
                         self.frame = rect;
                         self.tableView.frame = CGRectMake(5, 86, self.width-10, self.height-86-5-2);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)doHide {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rect = self.frame;
                         rect.size.height = 86;
                         self.frame = rect;
                     } completion:^(BOOL finished) {
                         if (self.choosenBlock) {
                             self.choosenBlock(self.edition);
                         }
                     }];
}

#pragma mark - table view datasource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        return 2;
    } else {
        return 45;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.editionItem.editions count] * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        YXDashLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dash"];
        cell.realWidth = 4;
        cell.dashWidth = 3;
        cell.preferedGapToCellBounds = 0;
        cell.bHasShadow = YES;
        cell.realColor = [UIColor colorWithHexString:@"e6bb47"];
        cell.shadowColor = [UIColor colorWithHexString:@"fff5cc"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        GetEditionRequestItem_edition *edition = self.editionItem.editions[indexPath.row / 2];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
        cell.textLabel.text = edition.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"805500"];
        cell.textLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
        cell.textLabel.layer.shadowOffset = CGSizeMake(0, 1);
        cell.textLabel.layer.shadowOpacity = 1;
        cell.textLabel.layer.shadowRadius = 0;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ((indexPath.row / 2 + 1) == [self.editionItem.editions count]) {
            UIImageView *cellSelectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选择教材弹出背景-拷贝"]];
            cell.selectedBackgroundView = cellSelectedBackgroundView;
        } else {
            UIView *cellSelectedBackgroundView = [[UIView alloc] init];
            cellSelectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"ffdb4d"];
            cell.selectedBackgroundView = cellSelectedBackgroundView;
        }

        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.edition = self.editionItem.editions[indexPath.row / 2];
    [self doHide];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

@end

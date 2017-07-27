//
//  EditNoteViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/13/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "EditNoteViewController.h"
#import "MistakeQuestionManager.h"
#import "QANoteImagesView.h"

@interface EditNoteViewController ()
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) QANoteImagesView *imagesView;
@property (nonatomic, strong) QAQuestion *editItem;
@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"笔记";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    UIButton *naviRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [naviRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [naviRightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    naviRightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    naviRightButton.layer.cornerRadius = 6;
    naviRightButton.layer.borderWidth = 2;
    naviRightButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    naviRightButton.clipsToBounds = YES;
    WEAK_SELF
    [[naviRightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self saveBarButtonTapped];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    self.textView = [[SAMTextView alloc]init];
    self.textView.text = self.editItem.noteText;
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    NSString *placeholderStr = @"请输入笔记详情";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:placeholderStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"cccccc"] range:NSMakeRange(0, placeholderStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, placeholderStr.length)];
    self.textView.attributedPlaceholder = attrStr;
    self.textView.textContainerInset = UIEdgeInsetsMake(25, 15, 25, 15);
    [self.contentView addSubview:self.textView];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(SCREEN_WIDTH, 99999)];
    CGFloat height = MAX(size.height, 200);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(1);
        make.height.mas_equalTo(height);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    line.layer.shadowOffset = CGSizeMake(0, 1);
    line.layer.shadowRadius = 1;
    line.layer.shadowOpacity = 0.02;
    line.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.imagesView = [[QANoteImagesView alloc]init];
    [self.imagesView updateWithPhotos:self.editItem.noteImages editable:YES];
    self.imagesView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    self.imagesView.layer.shadowOffset = CGSizeMake(0, 1);
    self.imagesView.layer.shadowRadius = 1;
    self.imagesView.layer.shadowOpacity = 0.02;
    self.imagesView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line.mas_bottom);
        make.height.mas_equalTo(105);
        make.bottom.mas_equalTo(-40);
    }];
    [self.view sendSubviewToBack:self.imagesView];
}

#pragma mark - Setter
- (void)setItem:(QAQuestion *)item {
    _item = item;
    
    self.editItem = [[QAQuestion alloc] init];
    self.editItem.noteImages = item.noteImages;
    self.editItem.noteText = item.noteText;
    self.editItem.wrongQuestionID = item.wrongQuestionID;
    self.editItem.questionID = item.questionID;
}

#pragma mark - Actions
- (void)saveBarButtonTapped {
    [self.view endEditing:YES];
    self.editItem.noteText = self.textView.text;
    if (isEmpty(self.editItem.noteText)) {
        self.editItem.noteText = @"";
    }
    
    WEAK_SELF
    [self.view nyx_startLoading];
    [self nyx_disableRightNavigationItem];
    [[MistakeQuestionManager sharedInstance] saveMistakeRedoNoteWithQuestion:self.editItem completeBlock:^(MistakeRedoNoteItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        [self nyx_enableRightNavigationItem];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        } else {
            self.item.noteText = self.editItem.noteText;
            self.item.noteImages = self.editItem.noteImages;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end

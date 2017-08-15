//
//  ClassInfoItemView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassInfoItemView.h"

@interface ClassInfoItemView()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *pencilButton;
@property (nonatomic, strong) UIButton *clearButton;
@end

@implementation ClassInfoItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupObserver];
        self.canEdit = NO;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"69ad0a"];
    self.clearButton = [[UIButton alloc]init];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除当前编辑文字icon正常态"] forState:UIControlStateNormal];
    [self.clearButton setBackgroundImage:[UIImage imageNamed:@"删除当前编辑文字icon点击态"] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clearButton];

    self.pencilButton = [[UIButton alloc]init];
    [self.pencilButton setImage:[UIImage imageNamed:@"班级编辑姓名icon正常态"] forState:UIControlStateNormal];
    [self.pencilButton setImage:[UIImage imageNamed:@"班级编辑姓名icon点击态"] forState:UIControlStateHighlighted];
    [self.pencilButton addTarget:self action:@selector(pencilAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.pencilButton];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"336600"];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    self.inputView = [[LoginInputView alloc]init];
    self.inputView.textField.delegate = self;
    [self addSubview:self.inputView];
}

- (void)setupObserver {
    WEAK_SELF
    [[self.inputView.textField rac_textSignal]subscribeNext:^(id x) {
        STRONG_SELF
        self.clearButton.hidden = isEmpty(x);
        BLOCK_EXEC(self.textChangeBlock)
    }];
}

- (void)clearAction {
    self.inputView.textField.text = @"";
    BLOCK_EXEC(self.textChangeBlock)
    self.clearButton.hidden = YES;
}

- (void)pencilAction {
    [self.inputView.textField becomeFirstResponder];
}

- (void)refreshPencilButton {
    if (self.canEdit && !self.inputView.textField.isFirstResponder && self.text.length>0) {
        self.pencilButton.hidden = NO;
    }else {
        self.pencilButton.hidden = YES;
    }
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (canEdit) {
        [self addSubview:self.clearButton];
        [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        [self addSubview:self.pencilButton];
        [self.pencilButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
            make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-17);
        }];
    }else {
        [self.clearButton removeFromSuperview];
        [self.pencilButton removeFromSuperview];
        [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(20);
            make.right.mas_equalTo(-17);
        }];
    }
    [self refreshPencilButton];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    [self.nameLabel sizeToFit];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(self.nameLabel.width);
    }];
}

- (NSString *)text {
    return [self.inputView.textField.text yx_stringByTrimmingCharacters];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.clearButton.hidden = textField.text.length==0;
    [self refreshPencilButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.clearButton.hidden = YES;
    [self refreshPencilButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

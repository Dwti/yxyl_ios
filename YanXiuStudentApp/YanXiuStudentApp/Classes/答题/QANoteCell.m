//
//  QANoteCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QANoteCell.h"
#import "QANoteImagesView.h"

@interface QANoteCell()
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QANoteImagesView *imagesView;
@end

@implementation QANoteCell

- (void)setupUI{
    [super setupUI];
    UIButton *editNoteButton = [[UIButton alloc]init];
    [editNoteButton setImage:[UIImage imageNamed:@"编辑笔记icon正常态"] forState:UIControlStateNormal];
    [editNoteButton setImage:[UIImage imageNamed:@"编辑笔记icon点击态"] forState:UIControlStateHighlighted];
    [editNoteButton setTitle:@"编辑笔记" forState:UIControlStateNormal];
    [editNoteButton setTitleColor:[UIColor colorWithHexString:@"69ad0a"] forState:UIControlStateNormal];
    [editNoteButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
    [editNoteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ccff00"]] forState:UIControlStateNormal];
    [editNoteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    editNoteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    editNoteButton.layer.borderColor = [UIColor colorWithHexString:@"69ad0a"].CGColor;
    editNoteButton.layer.borderWidth = 2;
    editNoteButton.layer.cornerRadius = 6;
    editNoteButton.clipsToBounds = YES;
    [editNoteButton addTarget:self action:@selector(editNoteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editNoteButton];
    [editNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(84, 26));
    }];
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    self.htmlView.backgroundColor = [UIColor clearColor];
    
    self.imagesView = [[QANoteImagesView alloc]init];
}

- (void)editNoteAction {
    
}

- (void)updateWithText:(NSString *)text images:(NSArray<QAImageAnswer *> *)images {
    [self.imagesView updateWithPhotos:[NSMutableArray arrayWithArray:images] editable:NO];
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForAnalysisItems];
    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringWithString:text options:dic];
    if (!isEmpty(text) && images.count == 0) {
        [self.contentView addSubview:self.htmlView];
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
            make.bottom.mas_equalTo(-15);
        }];
    }else if (isEmpty(text) && images.count > 0) {
        [self.contentView addSubview:self.imagesView];
        [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }else if (!isEmpty(text) && images.count > 0) {
        [self.contentView addSubview:self.htmlView];
        [self.contentView addSubview:self.imagesView];
        [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        }];
        [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.htmlView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(105);
            make.bottom.mas_equalTo(0);
        }];
    }
}

+ (CGFloat)maxContentWidth{
    return [UIScreen mainScreen].bounds.size.width - 15 - 15;
}

+ (CGFloat)heightForText:(NSString *)text images:(NSArray<QAImageAnswer *> *)images {
    if (!isEmpty(text) && images.count == 0) {
        CGFloat stringHeight = [QANoteCell heightForString:text];
        return stringHeight+15+14+15+15;
    }else if (isEmpty(text) && images.count > 0) {
        return 15+14+105;
    }else if (!isEmpty(text) && images.count > 0) {
        CGFloat stringHeight = [QANoteCell heightForString:text];
        return stringHeight+15+14+15+105;
    }else {
        return 15+14+15;
    }
}

+ (CGFloat)heightForString:(NSString *)string{
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = nil;
    dic = [YXQACoreTextHelper defaultOptionsForAnalysisItems];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    return stringHeight;
}


@end

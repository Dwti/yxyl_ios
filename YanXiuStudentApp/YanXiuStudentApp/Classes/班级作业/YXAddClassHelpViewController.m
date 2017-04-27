//
//  YXAddClassHelpViewController.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/5/4.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXAddClassHelpViewController.h"

@interface YXAddClassHelpViewController()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSArray *contents;

@end

@implementation YXAddClassHelpViewController

- (NSArray *)contents
{
    return @[
             @"什么是易学易练班级",
             @"班级是由老师在“易学易练老师端”中创建，给学生布置批改作业的班级群。\n每个易学易练班级都有一个8位数班级号码，如：“班级号码：12345678”",
             @"怎样加入班级",
             @"每一步，老师在“易学易练老师端”中创建班级，并将班级号码分享或告知学生们。\n第二步：同学在“易学易练学生端”作业页面，点击“加入班级”输入班级号码，即可加入班级，然后就可以通手机来完成来自老师布置的作业了。",
             ];
}

- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [NSMutableArray new];
        for (int i = 0; i < self.contents.count; i++) {
            UILabel *label = [UILabel new];
            label.numberOfLines = 0;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.contents[i]];
            NSRange range = NSMakeRange(0, str.length);
            if (i % 2) {
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = NSTextAlignmentJustified;//设置对齐方式
                paragraph.lineBreakMode = NSLineBreakByWordWrapping;
                paragraph.lineSpacing = 11;
                [str addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x996600] range:range];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            }else{
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBHex:0x805500] range:range];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
            }
            label.attributedText = str;
            [_labels addObject:label];
        }
    }
    return _labels;
}

#pragma mark-
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self yx_setupLeftBackBarButtonItem];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xfff0b2];
    self.title = @"怎样加入班级";
    for (int i = 0; i < self.labels.count; i++) {
        [self.view addSubview:self.labels[i]];
        [self.labels[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.right.offset = -20;
//            if (i % 2 == 0) {//标题行定死高度
//                make.height.mas_equalTo(17);
//            }
            if (i > 0) {
                CGFloat offset = i % 2? 15: 25;
                make.top.mas_equalTo([self.labels[i - 1] mas_bottom]).offset = offset;
            }else{
                make.top.offset = 25;
            }
        }];
    }
}

@end

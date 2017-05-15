//
//  HomeworkAddClassHelpViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HomeworkAddClassHelpViewController.h"

@interface HomeworkAddClassHelpViewController ()

@end

@implementation HomeworkAddClassHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"怎样加入班级?";
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    UILabel *questionLabel1 = [[UILabel alloc]init];
    questionLabel1.text = @"什么是易学易练班级";
    questionLabel1.textColor = [UIColor colorWithHexString:@"333333"];
    questionLabel1.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:questionLabel1];
    [questionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_right).mas_offset(9);
        make.centerY.mas_equalTo(imageView1.mas_centerY);
    }];
    UILabel *label1 = [self labelWithText:@"班级是由老师在“易学易练老师端”中创建，给学生布置批改作业的班级群。"];
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(questionLabel1.mas_left);
        make.top.mas_equalTo(questionLabel1.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-30);
    }];
    UILabel *label2 = [self labelWithText:@"每个易学易练班级都有一个8位数班级号码如：“班级号码：12345678“。"];
    [self.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_left);
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(label1.mas_right);
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageWithColor:[UIColor redColor]];
    [self.contentView addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView1.mas_left);
        make.top.mas_equalTo(label2.mas_bottom).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    UILabel *questionLabel2 = [questionLabel1 clone];
    questionLabel2.text = @"怎样加入班级";
    [self.contentView addSubview:questionLabel2];
    [questionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView2.mas_right).mas_offset(9);
        make.centerY.mas_equalTo(imageView2.mas_centerY);
    }];
    UILabel *label3 = [self labelWithText:@"第一步：老师在“易学易练教师端”中创建班级，并将班级号码分享或告知学生们。"];
    [self.contentView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(questionLabel2.mas_left);
        make.top.mas_equalTo(questionLabel2.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-30);
    }];
    UILabel *label4 = [self labelWithText:@"第二步：同学们在“易学易练学生端”作业页面，点击“加入班级”输入班级号码，即可加入班级，然后就可以通过手机来完成来自老师布置的作业了。"];
    [self.contentView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label3.mas_left);
        make.top.mas_equalTo(label3.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(label3.mas_right);
        make.bottom.mas_equalTo(-40);
    }];
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.font = [UIFont systemFontOfSize:16];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:text attributes:dic];
    label.attributedText = attrString;
    return label;
}

@end

//
//  YXFillBlankViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/13/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXFillBlankViewController.h"

@interface YXFillBlankViewController ()

@end

@implementation YXFillBlankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITextView *textStuff = [[UITextView alloc] init];
    textStuff.userInteractionEnabled = NO;
    textStuff.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    textStuff.font = [UIFont systemFontOfSize:20];
    textStuff.frame = CGRectMake(2.0, 100.0, self.view.bounds.size.width - 4, 300);
    textStuff.textColor = [UIColor blackColor];
    
    UIView *clearView = [[UIView alloc] initWithFrame:textStuff.bounds];
    clearView.backgroundColor = [UIColor clearColor];
    [textStuff addSubview:clearView];
    
    textStuff.userInteractionEnabled = YES;
    [self.view addSubview:textStuff];

    // 共9个
    NSString *text = @"鲁迅，原名（_）字（_），他的代表作品是小说集（_）、（_），散文集（_）。\n\
    鲁迅再《琐记》一文中，用了（_）来讥讽洋务派的办学。\n\
    鲁迅写出了中国现代第一篇白话小说（_），1918年在（_）上发表其后又发表（_）等著名小说。";
    
    NSString *pattern = @"（_）";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSString *outText = [reg stringByReplacingMatchesInString:text
                                                      options:NSMatchingReportCompletion
                                                        range:NSMakeRange(0, [text length])
                                                 withTemplate:@"（________）"];
    
    
    textStuff.text = outText;
    
    
    
    NSString *pattern2 = @"________";
    NSRegularExpression *reg2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:nil];
    NSArray* match = [reg2 matchesInString:outText options:NSMatchingReportCompletion range:NSMakeRange(0, [outText length])];
    
    if (match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            UITextField *tf = [[UITextField alloc] init];
            tf.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            tf.frame = [self frameOfTextRange:[matc range] inTextView:textStuff];
            [textStuff addSubview:tf];
        }
    }
    
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

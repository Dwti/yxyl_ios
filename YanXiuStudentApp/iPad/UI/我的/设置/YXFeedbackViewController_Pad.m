//
//  YXFeedbackViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXFeedbackViewController_Pad.h"
#import "YXFeedbackRequest.h"
#import "YXCommonButton.h"
#import "YXLoginCell.h"

@interface YXFeedbackViewController_Pad ()

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) YXCommonButton *sendButton;

@property (nonatomic, strong) YXFeedbackRequest *feedbackRequest;

@end

@implementation YXFeedbackViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[YXLoginCell class] forCellReuseIdentifier:kYXLoginCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SAMTextView *)textView
{
    if (!_textView) {
        _textView = [[SAMTextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        NSString *placeholder = @"请描述您遇到的问题，或对我们提出宝贵建议...（4~500字）";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder];
        [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, placeholder.length)];
        _textView.attributedPlaceholder = attrString;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.tintColor = [UIColor whiteColor];
        _textView.clipsToBounds = YES;
        _textView.textColor = [UIColor whiteColor];
        _textView.layer.shadowColor = [UIColor colorWithHexString:@"bd8e00"].CGColor;
        _textView.layer.shadowOffset = CGSizeMake(0, 1);
        _textView.layer.shadowRadius = 0;
        _textView.layer.shadowOpacity = 1;
    }
    return _textView;
}

- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        UIImageView *feedbackBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"搜索列表背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        feedbackBgView.userInteractionEnabled = YES;
        [_inputView addSubview:feedbackBgView];
        [feedbackBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        UIImageView *textBgView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"输入框背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        textBgView.userInteractionEnabled = YES;
        [feedbackBgView addSubview:textBgView];
        [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.bottom.right.mas_equalTo(-15);
        }];
        [textBgView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.bottom.right.mas_equalTo(-10);
        }];
    }
    return _inputView;
}

- (YXCommonButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[YXCommonButton alloc] init];
        [_sendButton setTitle:@"发 送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return self.inputView;
        case 1:
            return self.sendButton;
        default:
            return nil;
    }
}

- (void)sendAction
{
    [self.textView resignFirstResponder];
    NSString *content = self.textView.text;
    if (content.length < 4) {
        [self yx_showToast:@"您的反馈字数太少啦！"];
        return;
    }
    if (content && content.length > 500) {
        self.textView.text = [content substringToIndex:500];
    }
    
    if (self.feedbackRequest) {
        [self.feedbackRequest stopRequest];
    }
    self.feedbackRequest = [[YXFeedbackRequest alloc] init];
    self.feedbackRequest.content = content;
    @weakify(self);
    [self yx_startLoading];
    [self.feedbackRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (!item || error) {
            [self yx_showToast:@"发送失败！"];
        } else {
            [self yx_showToast:@"发送成功！"];
            [self performSelector:@selector(yx_leftBackButtonPressed:) withObject:nil afterDelay:1];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginCellIdentifier];
    cell.containerView = [self viewForRowAtIndexPath:indexPath];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 230.f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

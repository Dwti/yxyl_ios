//
//  EditNoteViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/13/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "EditNoteViewController.h"
#import "YXBarButtonItemCustomView.h"
#import "UIViewController+YXNavigationItem.h"
#import "YXPhotoBrowser.h"
#import "YXPhotoListViewController.h"
#import "MistakeQuestionManager.h"
#import "MistakeNoteTableViewCell.h"


@interface EditNoteViewController () <
YXQASubjectiveAddPhotoHandlerDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) YXQASubjectiveAddPhotoHandler *addPhotoHandler;
@property (nonatomic, strong) QAQuestion *editItem;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - UI
- (void)setupUI {
    self.addPhotoHandler = [[YXQASubjectiveAddPhotoHandler alloc]initWithViewController:self];
    self.addPhotoHandler.delegate = self;
    
    [self setupBG];
    [self setupTitle];
    [self setupLeft];
    [self setupRight];
    [self setupContentView];
    [self setupMaskView];
    [self setupRAC];
}

- (void)setupBG{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"桌面"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UIImage *bookImage = [UIImage imageNamed:@"book"];
    bookImage = [bookImage stretchableImageWithLeftCapWidth:50 topCapHeight:50];
    UIImageView *bookImageView = [[UIImageView alloc]initWithImage:bookImage];
    bookImageView.userInteractionEnabled = YES;
    [self.view addSubview:bookImageView];
    [bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 0, 3, 2));
    }];
}

- (void)setupTitle{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"重新做题"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(146, 40));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"006666"];
    label.text = @"笔记";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.shadowColor = [UIColor colorWithHexString:@"33ffff"].CGColor;
    label.layer.shadowRadius = 0;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(2);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-12);
    }];
}

- (void)setupRight{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(56, 40));
    }];
    [button addTarget:self action:@selector(saveBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLeft {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"取消icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"取消icon-按下"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 - 28);
        make.top.mas_equalTo(26 - 28);
        make.size.mas_equalTo(CGSizeMake(28*3, 28*3));
    }];
    [button addTarget:self action:@selector(backBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupContentView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 10, 30, 17));
    }];
    
    [self.tableView registerClass:[MistakeNoteTableViewCell class] forCellReuseIdentifier:@"MistakeNoteTableViewCell"];
}

- (void)setupMaskView{
    UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage stretchImageNamed:@"遮罩"]];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 10, 30, 17));
    }];
}

- (void)setupRAC {
    WEAK_SELF;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillShow:x];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF;
        [self keyboardWillHide:x];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:CGRectGetHeight(keyboardFrame)]; 
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIViewAnimationCurve curve = (UIViewAnimationCurve)((NSNumber *)[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]).intValue;
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = curve << 16;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self resetViewWithKeyboardHeight:0];
    } completion:nil];
}

- (void)resetViewWithKeyboardHeight:(CGFloat)keyboardHeight {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
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
    
    if (isEmpty(self.editItem.noteText)) {
        self.editItem.noteText = @"";
    }
    
    WEAK_SELF
    [self yx_startLoading];
    [[MistakeQuestionManager sharedInstance] saveMistakeRedoNoteWithQuestion:self.editItem completeBlock:^(MistakeRedoNoteItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        } else {
            self.item.noteText = self.editItem.noteText;
            self.item.noteImages = self.editItem.noteImages;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)backBarButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MistakeNoteTableViewCell heightForNoteWithQuestion:self.editItem isEditable:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MistakeNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MistakeNoteTableViewCell" forIndexPath:indexPath];
    
    cell.isEditable = YES;
    cell.questionItem = self.editItem;
    cell.delegate = self.addPhotoHandler;
    [cell reloadViewWithArray:self.editItem.noteImages addEnable:YES];
    
    WEAK_SELF
    [cell setTextDidChange:^(NSString *text) {
        STRONG_SELF
        self.editItem.noteText = text;
    }];
    
    [cell setPhotosChangedBlock:^(NSArray *images) {
       STRONG_SELF
//        self.editItem.noteImages = images;
    }];
    
    return cell;
}


#pragma mark - YXQASubjectiveAddPhotoHandlerDelegate
- (UIViewController *)photoListVCWithViewModel:(YXAlbumViewModel *)viewModel title:(NSString *)title{
    UIViewController *viewController = [[YXPhotoListViewController alloc] initWithViewModel:viewModel];
    
    viewController.title = title;
    UINavigationController *navi = [[YXNavigationController alloc]initWithRootViewController:viewController];
    return navi;
}

- (MWPhotoBrowser *)photoBrowserWithTitle:(NSString *)title currentIndex:(NSInteger)index canDelete:(BOOL)canDelete{
    YXPhotoBrowser * photoBrowser = [[YXPhotoBrowser alloc] initWithDelegate:self.addPhotoHandler];
    photoBrowser.title = title;
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = YES;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    
    [photoBrowser setCurrentPhotoIndex:index];
    [photoBrowser hiddenRightBarButtonItem:!canDelete];
    @weakify(self);
    photoBrowser.deleteHandle = ^(){
        @strongify(self);
        [self.addPhotoHandler showDeleteActionSheet];
    };
    return photoBrowser;
}
@end

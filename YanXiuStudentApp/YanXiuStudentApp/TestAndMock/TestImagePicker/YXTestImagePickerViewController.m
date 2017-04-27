//
//  YXTestImagePickerViewController.m
//  YanXiuStudentApp
//
//  Created by wd on 15/9/25.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXTestImagePickerViewController.h"
#import "YXAlbumListViewController.h"
#import "YXAlbumViewModel.h"
#import "YXAddPhotoView.h"
#import "YXPhotoManager.h"
#import "YXPhotoModel.h"
#import "YXAVPlayerManager.h"
#import "YXPhotoBrowser.h"

@interface YXTestImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YXAVPlayerManagerDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) UIActionSheet *       sheetView;
@property (nonatomic, strong) YXAddPhotoView *      addView;
@property (nonatomic, strong) YXAVPlayerManager *   AVPlayer;
@property (nonatomic, strong) YXPhotoBrowser *      photoBrowser;
@property (nonatomic, assign) NSUInteger            currentPositonPhoto;
@end

@implementation YXTestImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    @weakify(self);
    //    UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
    //    button.backgroundColor = [UIColor clearColor];
    //    [button setTitle:@"选择" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    //    [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //        @strongify(self);
    //        make.center.equalTo(self.view);
    //        make.size.mas_equalTo(CGSizeMake(50, 20));
    //    }];
#if 0   //Test AVPlayer
    self.AVPlayer = [YXAVPlayerManager shareManager];
    NSString * str = [[NSBundle mainBundle] pathForResource:@"陈淑桦 - 梦醒时分" ofType:@"mp3"];
    [self.AVPlayer yx_prepareToPlayWithURL:str delegate:self];
#endif
    self.addView = [[YXAddPhotoView alloc] initWithFrame:CGRectZero addEnable:YES];
    self.addView.backgroundColor = [UIColor clearColor];
    self.addView.userInteractionEnabled = YES;
    [self.view addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.sheetView = [[UIActionSheet alloc] initWithTitle: @"选择" delegate: nil cancelButtonTitle: nil destructiveButtonTitle: @"取消" otherButtonTitles: @"从相册选择", @"拍照", nil];
    } else {
        self.sheetView = [[UIActionSheet alloc] initWithTitle: @"选择" delegate: nil cancelButtonTitle: nil destructiveButtonTitle: @"取消" otherButtonTitles: @"从相册选择", nil];
    }
    [[self.sheetView.rac_buttonClickedSignal deliverOnMainThread] subscribeNext: ^(NSNumber* index) {
        NSUInteger sourceType = 0;
        switch (index.integerValue) {
            case 0:
            {
                return;
            }
                break;
            case 1:
            {
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    YXAlbumViewModel * albumViewModel = [[YXAlbumViewModel alloc] init];
                    YXAlbumListViewController * albumListViewController = [[YXAlbumListViewController alloc] initWithViewModel:albumViewModel];
                    UINavigationController * albumNav = [[UINavigationController alloc] initWithRootViewController:albumListViewController];
                    [self presentViewController:albumNav animated:YES completion:^{}];
                }
            }
                break;
            case 2:
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
                
                imagePickerController.delegate = self;
                
                NSMutableArray* mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject: (__bridge NSString*) kUTTypeImage];
                imagePickerController.mediaTypes = mediaTypes;
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = sourceType;
                [imagePickerController.navigationBar setTintColor: [UIColor blackColor]];
                [self presentViewController: imagePickerController animated: YES completion: ^{}];
                
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view layoutIfNeeded];
    [self setupRAC];
    
}

- (void)setupRAC
{
    @weakify(self);
    [[RACObserve(PHOTOMANAGER, photosArray) deliverOnMainThread] subscribeNext:^(NSArray * photosArray) {
        @strongify(self);
        [self.addView reloadWithPhotosArray:photosArray];
        [self.addView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo([self.addView getHight]);
        }];
    }];
    self.addView.photoHandle = ^(NSInteger nInteger){
        @strongify(self);
        YXPhotoBrowser * photoBrowser = [[YXPhotoBrowser alloc] initWithDelegate:self];
        photoBrowser.displayActionButton = NO;
        photoBrowser.displayNavArrows = YES;
        photoBrowser.displaySelectionButtons = NO;
        photoBrowser.alwaysShowControls = NO;
        photoBrowser.zoomPhotosToFill = YES;
        photoBrowser.enableGrid = NO;
        photoBrowser.startOnGrid = NO;
        photoBrowser.enableSwipeToDismiss = NO;
        
        [photoBrowser setCurrentPhotoIndex:nInteger];
        self.photoBrowser = nil;
        self.photoBrowser = photoBrowser;
        [self addDeleteHandle];
        [self.navigationController pushViewController:photoBrowser animated:YES];
        
    };
    self.addView.addHandle = ^(){
        @strongify(self);
        if (self.sheetView) {
            [self.sheetView showInView: self.view];
        }
    };

}
- (void)addDeleteHandle
{
    self.photoBrowser.deleteHandle = ^(){
        NSLog(@"删除");
    };
}
- (void)buttonClicked:(UIButton *)sender
{
    if (self.sheetView) {
        [self.sheetView showInView: self.view];
    }
}
#pragma mark - image picker delegte
- (void) imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [picker dismissViewControllerAnimated: YES completion: ^{}];
    //TODO.选择的照片。
//    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController*) picker
{
    [self dismissViewControllerAnimated: YES completion: ^{}];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [PHOTOMANAGER.photosArray count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    DDLogDebug(@"%@", @(index));
    if (index < [PHOTOMANAGER.photosArray count])
    {
        YXPhotoModel * model = PHOTOMANAGER.photosArray[index];
//        MWPhoto * photo = [MWPhoto photoWithImage:[PHOTOMANAGER getImageFromAsset:model.alasset type:YXPhotoAssetType_ScreenSize]];
        return model;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < [PHOTOMANAGER.photosArray count])
        return PHOTOMANAGER.photosArray[index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    self.currentPositonPhoto = index;
}
#pragma mark AVPlayerManagerDelegate
//播放失败
- (void)AVPlayer:(AVPlayer *)player playbackError:(YXAVPlaybackError)error
{

}
//播放状态
- (void)AVPlayer:(AVPlayer *)player playbackStateChanged:(YXAVPlaybackState)state
{

}
//播放结束
- (void)AVPlayerDidFinish:(AVPlayer *)player
{

}
//播放开始
- (void)AVPlayerDidPreload:(AVPlayer *)player
{

}

@end

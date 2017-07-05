//
//  TestClassifyViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TestClassifyViewController.h"
#import "QAClassifyOptionCell.h"
#import "QAClassifyOptionInfo.h"
#import "QAClassifyTextOptionCell.h"
#import "CollectionViewEqualSpaceFlowLayout.h"


@interface TestClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<QAClassifyOptionInfo *> *optionInfoArray;
@end

@implementation TestClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    NSArray *arr = @[@"肥肉节日哦",@"fei erign gerg reing gergi",@"丰富热不过更热弄人通融通过",@"给你二哥光荣通过Orthodox后庭花能够以让他很难跟肉感让他该内容呢干呢org干牛肉汤该内容个north",@"版本",@"啦啦啦",@"nirngrtngnrothnortnhortnhortnhortnhortnorhnorothnorthnoirgenorenog",@"h",@"哈"];
    arr = @[
            @"<src=\"http://pic30.nipic.com/20130615/12251844_141425397124_2.jpg\">",
            @"<src=\"http://img2.3lian.com/2014/f3/41/d/1.jpg\">",
            @"<src=\"http://pic.58pic.com/58pic/13/19/69/97x58PICw7N_1024.jpg\">",
            @"<src=\"http://pic1.nipic.com/2008-11-06/200811621332629_2.jpg\">",
            @"<src=\"http://pic17.nipic.com/20111121/859324_173958726133_2.jpg\">",
            @"<src=\"http://pic9.nipic.com/20100913/5655940_095542077929_2.jpg\">",
            @"<src=\"http://pic.nipic.com/2007-11-16/20071116151559583_2.jpg\">",
            @"<src=\"http://pic9.nipic.com/20100907/194672_155600029632_2.jpg\">",
            @"<src=\"http://cdn.duitang.com/uploads/item/201408/21/20140821125616_hJ8Ns.jpeg\">"
            ];
//    arr = @[@"<src=\"http://pic9.nipic.com/20100907/194672_155600029632_2.jpg\">"];
    self.optionInfoArray = [NSMutableArray array];
    for (NSString *option in arr) {
        QAClassifyOptionInfo *info = [[QAClassifyOptionInfo alloc]init];
        info.option = option;
        QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:option];
        info.size = [cell defaultSize];
        [self.optionInfoArray addObject:info];
    }
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *layout = [[CollectionViewEqualSpaceFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 5);
//    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.allowsMultipleSelection = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    QAClassifyOptionCell *cell = [QAClassifyOptionCell cellWithOption:self.optionInfoArray.firstObject.option];
    [self.collectionView registerClass:[cell class] forCellWithReuseIdentifier:@"OptionCell"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.optionInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QAClassifyOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionCell" forIndexPath:indexPath];
    WEAK_SELF
    [cell setSizeChangedBlock:^(CGSize size){
        STRONG_SELF
        if (!CGSizeEqualToSize(size, self.optionInfoArray[indexPath.row].size)){
            self.optionInfoArray[indexPath.row].size = size;
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];
    cell.optionString = self.optionInfoArray[indexPath.row].option;
    //    cell.canDelete = YES;
    cell.selected = self.optionInfoArray[indexPath.row].selected;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.optionInfoArray[indexPath.row].size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.optionInfoArray[indexPath.row].selected = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.optionInfoArray[indexPath.row].selected = NO;
}

@end

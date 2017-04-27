//
//  YXAddPhotoView.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXAddPhotoView.h"
#import "YXPhotoModel.h"

#define photoWidth  52
#define AddButtonTag 55555
#define heightSpaceDistance 10


@interface YXAddPhotoView()
@property (nonatomic, assign) CGFloat selfHeight;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) NSInteger photoNumberPerRow;
@property (nonatomic, strong) NSMutableArray *photosArray;
@end


@implementation YXAddPhotoView

- (instancetype)initWithFrame:(CGRect)frame addEnable:(BOOL)enable {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 10 - 70 - 17 /*背景距离边*/ - 20 /*选项框距背景*/;
    return [self initWithFrame:frame photoNumberPerRow:4 maxWidth:width addEnable:enable];
}

- (instancetype)initWithFrame:(CGRect)frame
            photoNumberPerRow:(NSInteger)photoNumber
                     maxWidth:(CGFloat)maxWidth
                    addEnable:(BOOL)enable {
    
    if (self = [super initWithFrame:frame]) {
        _addEnable = enable;
        _photoNumberPerRow = photoNumber;
        _maxWidth = maxWidth;
    }
    
    return self;
}

- (void)reloadWithPhotosArray:(NSArray *)photosArray {
    self.backgroundColor = [UIColor colorWithHexString:@"fff7d9"];
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    self.photosArray = [[NSMutableArray alloc] initWithArray:photosArray];
    
    if (self.addEnable) {
        if (isEmpty(self.photosArray)) {
            [self addUploadAnswerButton];
        } else {
            [self addImageAnswerButton:self.addEnable];
        }
    } else {
        [self addImageAnswerButton:self.addEnable];
    }
}

- (void)addUploadAnswerButton {
    self.selfHeight = 54;

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nImage = [[UIImage imageNamed:@"添加答案按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 60, 12, 60)];
    UIImage *sImage = [[UIImage imageNamed:@"添加答案按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 60, 12, 60)];
    [addBtn setBackgroundImage:nImage forState:UIControlStateNormal];
    [addBtn setBackgroundImage:sImage forState:UIControlStateHighlighted];
    
    addBtn.frame = CGRectMake(0, 0, self.maxWidth, 54);
    addBtn.tag = AddButtonTag;
    
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    addBtn.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    addBtn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    addBtn.titleLabel.layer.shadowOpacity = 1;
    addBtn.titleLabel.layer.shadowRadius = 0;
    [addBtn setTitle:@"上传答案" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];

    [addBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:addBtn];
    
    if (self.adjustAddButton) {
        self.adjustAddButton(addBtn);
    }
}

- (void)addImageAnswerButton: (BOOL)addEnable {
    int count = MIN(9, (int)[self.photosArray count] + 1);
    NSInteger row = (count + self.photoNumberPerRow - 1) / self.photoNumberPerRow;
    self.selfHeight = row * (55 + 8);
    
    CGFloat hGap = floorf(self.maxWidth - 55 * self.photoNumberPerRow) / (self.photoNumberPerRow - 1);
    hGap = MAX(1.5, hGap);
    
    [self.photosArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.layer.cornerRadius = 6;
        [btn.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
        }];
        [btn setBackgroundImage:[UIImage imageNamed:@"主观题继续上传边框"] forState:UIControlStateNormal];
        
        YXPhotoModel *model = obj;
        UIImage *image = model.thumbImage;
        if (!image) {
            [btn sd_setImageWithURL:[NSURL URLWithString:model.thumbImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"jiexiDefaultImage"]];
        }else{
            [btn setImage:image forState:UIControlStateNormal];
        }
        CGFloat x = (55 + hGap) * (idx % self.photoNumberPerRow);
        CGFloat y = (55 + 8) * (idx / self.photoNumberPerRow);
        btn.frame = CGRectMake(x, y, 55, 55);
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    
    if (addEnable) {
        if ([self.photosArray count] < 9) {
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"+号按钮-按下"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"+号按钮"] forState:UIControlStateHighlighted];
            
            CGFloat x = (55 + hGap) * ([self.photosArray count] % self.photoNumberPerRow);
            CGFloat y = (55 + 8) * ([self.photosArray count] / self.photoNumberPerRow);
            btn2.frame = CGRectMake(x, y, 55, 55);
            btn2.tag = AddButtonTag;
            [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn2];
        }
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == AddButtonTag) {
        if (self.addHandle) {
            self.addHandle();
        }
    } else if(self.photoHandle) {
        self.photoHandle(sender.tag);
    }
}

- (CGFloat)getHight {
    return self.selfHeight;
}

@end

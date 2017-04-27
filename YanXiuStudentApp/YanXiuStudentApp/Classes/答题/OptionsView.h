//
//  OptionsView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OptionsDataType) {
    OptionsImageDataType,
    OptionsStringDataType,
};

typedef void (^DeleteBlock)(id obj);
typedef void (^InsertBlock)(id obj);

@interface OptionsView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, assign) CGFloat estimatedHeight;
@property (nonatomic, weak) UIView *currentView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) DeleteBlock deleteBlock;
@property (nonatomic, copy) InsertBlock insertBlock;
@property (nonatomic, strong) UIScrollView *bgScrollView;

- (void)setDeleteBlock:(DeleteBlock)deleteBlock;
- (void)setInsertBlock:(InsertBlock)insertBlock;
- (UIButton *)closeButtonWithObj:(id)obj;

- (instancetype)initWithDataType:(OptionsDataType)type;

@end

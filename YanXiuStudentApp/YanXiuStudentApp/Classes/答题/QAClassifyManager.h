//
//  QAClassifyManager.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionsView.h"
#import "YXClassesView.h"
#import "QAClassifyAnswersView.h"
#import "QAClassifyOptionsCell.h"

typedef void(^OptionChangeBlock) (void);

@protocol QAClassifyManagerDelegate <NSObject>
- (void)updateRedoStatus;
@end

@interface QAClassifyManager : NSObject

@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger currentClassesIndex;
@property (nonatomic, assign) OptionsDataType type;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, weak) YXClassesView *classesView;
@property (nonatomic, weak) QAClassifyAnswersView *answersView;
@property (nonatomic, weak) UIView *currentView;
@property (nonatomic, weak) QAClassifyOptionsCell *optionsCell;
@property (nonatomic, weak) id<QAClassifyManagerDelegate> redoStatusDelegate;

- (long)totalWithAnwers:(NSArray *)anwers;
- (void)sortOptions;

- (void)setOptionChangeBlock:(OptionChangeBlock)block;

@end

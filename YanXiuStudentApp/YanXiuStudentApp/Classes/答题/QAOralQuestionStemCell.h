//
//  QAOralQuestionStemCell.h
//  YanXiuStudentApp-iPhone
//
//  Created by LiuWenXing on 2017/10/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAOralQuestionStemCell : UITableViewCell
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, copy) void (^audioBtnBlock)(UIButton *sender, NSURL *audioUrl);

- (void)updateWithString:(NSString *)string isSubQuestion:(BOOL)isSub;
+ (CGFloat)heightForString:(NSString *)string isSubQuestion:(BOOL)isSub;
@end

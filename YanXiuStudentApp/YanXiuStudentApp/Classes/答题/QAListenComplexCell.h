//
//  QAListenComplexCell.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAListenComplexCell : UITableViewCell

@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;

- (void)stop;

@end

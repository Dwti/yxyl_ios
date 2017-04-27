//
//  YXFeedbackView.h
//  YanXiuStudentApp
//
//  Created by wd on 15/11/3.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ContentShowType)
{
    ContentShowType_Feedback = 0, // default
    ContentShowType_ReportError,
    
};


@interface YXFeedbackView : UIView

@property (nonatomic, strong) SAMTextView    *textView;
@property (nonatomic, strong) UIImageView   *backgroundView;
//@property (nonatomic, strong) UILabel       *numbersLabel;
- (instancetype)initWithFrame:(CGRect)frame showType:(ContentShowType)showType;
@end

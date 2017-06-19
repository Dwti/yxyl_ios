//
//  QAAlertButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAAlertButton.h"

@implementation QAAlertButton

- (void)setStyle:(QAAlertActionStyle)style {
    _style = style;
    if (style == QAAlertActionStyle_Cancel) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor colorWithHexString:@"69ad0a"].CGColor;
        self.layer.borderWidth = 2.0f;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor colorWithHexString:@"69ad0a"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
    }
    else if (style == QAAlertActionStyle_Default){
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    }else if(style == QAAlertActionStyle_Alone){
//        [self setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"003686"]] forState:UIControlStateHighlighted];
//        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
}


@end

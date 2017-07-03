//
//  SimpleAlertButton.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/4.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SimpleAlertButton.h"

@implementation SimpleAlertButton

- (void)setStyle:(SimpleAlertActionStyle)style {
    _style = style;
    if (style == SimpleAlertActionStyle_Cancel) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateNormal];
    }
    else if (style == SimpleAlertActionStyle_Default){
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }else if(style == SimpleAlertActionStyle_Alone){
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        [self setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
}

@end

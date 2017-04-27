//
//  QASlideItemBaseView.h
//  SlideDemo
//
//  Created by niuzhaowang on 2016/9/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QASlideItemBaseView : UIView
@property (nonatomic, assign) BOOL isForeground; // subclass should not change this value.

- (void)enterForeground; // subclass can override this method to do someting when view enters foreground.
- (void)leaveForeground; // subclass can override this method to do someting when view leaves foreground.
@end

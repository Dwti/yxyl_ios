//
//  ChooseAlbumListButton.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/4/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAlbumListButton : UIButton
@property (nonatomic, assign) BOOL bExpand;
- (void)updateWithTitle:(NSString *)title;
@end

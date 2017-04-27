//
//  MistakeTreeCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/28/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "TreeBaseCell.h"
#import "MistakeChapterListRequest.h"
#import "MistakeKnpListRequest.h"

@interface MistakeTreeCell : TreeBaseCell
@property (nonatomic, strong) MistakeChapterListRequestItem_chapter *chapter;
@property (nonatomic, strong) MistakeKnpListRequestItem_knp *knp;
@property (nonatomic, copy) void (^expandBlock) (MistakeTreeCell *cell);
@property (nonatomic, copy) void (^clickBlock) (MistakeTreeCell *cell);
@end

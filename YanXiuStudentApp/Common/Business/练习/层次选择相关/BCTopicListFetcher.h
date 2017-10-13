//
//  BCTopicListFetcher.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface BCTopicListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *order; //0-字母升序，1-字母降序，10-浏览数降序
@property (nonatomic, copy) NSString *scope; //查询范围 0-全部，1-已做答，2-未作答
@end

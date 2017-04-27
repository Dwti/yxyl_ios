//
//  MistakeRedoNoteRequest.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/6/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"
#import "QAQuestion.h"

@interface MistakeRedoNoteItem : HttpBaseRequestItem
@end

@interface MistakeNote: JSONModel
@property (nonatomic, copy) NSString<Optional> *qid;
@property (nonatomic, copy) NSString<Optional> *text;
@property (nonatomic, copy) NSArray<Optional> *images;
@end

@interface SaveMistakeNoteRequest : YXPostRequest
@property (nonatomic, copy) NSString *wqid;
@property (nonatomic, copy) NSString *note;
@end

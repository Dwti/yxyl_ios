//
//  QACoreTextViewHandler.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QACoreTextViewHandler.h"


@interface QACoreTextViewHandler()<DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

@property(nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, assign) CGFloat maxWidth;

@end


@implementation QACoreTextViewHandler

- (instancetype)initWithCoreTextView:(DTAttributedTextContentView *)view maxWidth:(CGFloat)width {
    if (self = [super init]) {
        self.htmlView = view;
        self.maxWidth = width;
        self.htmlView.shouldDrawImages = NO;
        self.htmlView.delegate = self;
    }
    return self;
}

#pragma mark -Core Text Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 2)];
        [bgView addSubview:imageView];
        imageView.frame = CGRectMake(1, 1, 0, 0);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        return bgView;
//        return imageView;
    }
    return nil;
}

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    CGFloat maxWidth = self.maxWidth;
    CGSize scaledSize = CGSizeMake(size.width/[UIScreen mainScreen].scale, size.height/[UIScreen mainScreen].scale);
    if (scaledSize.width > maxWidth) {
        CGFloat height = scaledSize.height * maxWidth / scaledSize.width;
        scaledSize = CGSizeMake(maxWidth, floorf(height));
    }
    
    BOOL needUpdate = NO;
    // update all attachments that matching this URL
    for (DTTextAttachment *oneAttachment in [self.htmlView.layoutFrame textAttachmentsWithPredicate:pred]) {
        if (!CGSizeEqualToSize(oneAttachment.displaySize, scaledSize)) {
            oneAttachment.displaySize = scaledSize;
            oneAttachment.verticalAlignment = DTTextAttachmentVerticalAlignmentCenter;
            needUpdate = YES;
        }
    }
    if (needUpdate) {
        // need to reset the layouter because otherwise we get the old framesetter or cached layout frames
        self.htmlView.layouter = nil;
        
        // here we're layouting the entire string,
        // might be more efficient to only relayout the paragraphs that contain these attachments
        [self.htmlView relayoutText];
        BLOCK_EXEC(self.relayoutBlock);
    }
}

- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    BLOCK_EXEC(self.heightChangeBlock,ceilf(layoutFrame.frame.size.height));
}

@end

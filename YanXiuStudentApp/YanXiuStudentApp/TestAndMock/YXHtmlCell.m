//
//  YXHtmlCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/13/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXHtmlCell.h"
#import <DTCoreText.h>
@interface YXHtmlCell () <DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) DTAttributedTextContentView *myView;
@end

@implementation YXHtmlCell {
    UIView *_helperView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    DTAttributedTextContentView *v = [[DTAttributedTextContentView alloc] init];
    v.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(0);
        make.left.mas_equalTo(60);
        make.top.bottom.right.mas_equalTo(0);
    }];
    v.shouldDrawImages = NO;
    v.delegate = self;
    self.myView = v;
}

- (void)updateWithData:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.25], NSTextSizeMultiplierDocumentOption, [UIColor greenColor], DTDefaultTextColor, nil];
    
    self.myView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:option documentAttributes:nil];
    [self.myView relayoutText];
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.delegate = self;
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        // url for deferred loading
        imageView.url = attachment.contentURL;
        return imageView;
    }
    return nil;
}

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    if (size.width > self.bounds.size.width - 20) {
        CGFloat height = size.height * (self.bounds.size.width - 20) / size.width;
        size = CGSizeMake(self.bounds.size.width - 20, floorf(height));
    }
    // update all attachments that matching this URL
    for (DTTextAttachment *oneAttachment in [self.myView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        oneAttachment.originalSize = size;
        oneAttachment.verticalAlignment = DTTextAttachmentVerticalAlignmentCenter;
    }
    
    // need to reset the layouter because otherwise we get the old framesetter or cached layout frames
    self.myView.layouter = nil;
    
    // here we're layouting the entire string,
    // might be more efficient to only relayout the paragraphs that contain these attachments
    [self.myView relayoutText];
}

- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    [self.delegate htmlCell:self updateWithHeight:layoutFrame.frame.size.height];
}
@end

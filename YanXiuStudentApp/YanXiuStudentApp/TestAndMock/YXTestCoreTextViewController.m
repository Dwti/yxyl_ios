//
//  YXTestCoreTextViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/13/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXTestCoreTextViewController.h"
#import <DTCoreText.h>
@interface YXTestCoreTextViewController () <DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) DTAttributedLabel *label;
@property (nonatomic, strong) DTAttributedTextContentView *myView;
@end

@implementation YXTestCoreTextViewController {
    int index;
}

- (void)viewDidLoad {
    index = 0;
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"GO" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 100, 44, 44);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor greenColor];
    [btn2 setTitle:@"GO2" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 150, 44, 44);
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    DTAttributedTextContentView *v = [[DTAttributedTextContentView alloc] init];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    v.attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-100);
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
    }];
    v.shouldDrawImages = NO;
    v.delegate = self;
    self.myView = v;
}

- (void)btn2Action {

    DTCoreTextLayoutFrame *theLayoutFrame = self.myView.layoutFrame;
    CGRect frame = [theLayoutFrame frameOfGlyphAtIndex:index];
    UIView *v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = [UIColor blueColor];
    [self.myView addSubview:v];
    index++;
    
    /*
    NSArray *arr = [theLayoutFrame stringIndices];
    NSAttributedString *layoutString = [theLayoutFrame attributedStringFragment];
    NSString *str = [layoutString string];
     */
    
    
//    NSArray *lines;
//    lines = [theLayoutFrame lines];
//    
//    
//    for (DTCoreTextLayoutLine *oneLine in lines)
//    {
//        NSUInteger skipRunsBeforeLocation = 0;
//        
//            // add custom views if necessary
//            CGRect frameForSubview = CGRectZero;
//            NSRange effectiveRangeOfLink;
//            effectiveRangeOfLink.length = 10;
//            effectiveRangeOfLink.location = 0;
//            frameForSubview = [oneLine frameOfGlyphAtIndex:2];//[oneLine frameOfGlyphsWithRange:effectiveRangeOfLink];
//            
//            UIView *v = [[UIView alloc] init];
//            v.frame = frameForSubview;
//            v.backgroundColor = [UIColor blueColor];
//            [self.myView addSubview:v];
//        
//        
//    }
}

- (void)btnAction {
    static int i = 1;
    i = i % 3;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", @(i)] ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.label.attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
    
    [self.label relayoutText];
    [self.label sizeToFit];
    
    
    self.myView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
    i++;
}

- (void)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView didDrawLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame inContext:(CGContextRef)context {
    //DDLogError(@"%@", NSStringFromCGRect(layoutFrame.frame));
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

@end

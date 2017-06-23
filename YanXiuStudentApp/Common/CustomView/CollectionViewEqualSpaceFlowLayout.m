//
//  CollectionViewEqualSpaceFlowLayout.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/1/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CollectionViewEqualSpaceFlowLayout.h"

@implementation CollectionViewEqualSpaceFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    for(int i = 1; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
        if (currentLayoutAttributes.representedElementCategory != UICollectionElementCategoryCell ||
            prevLayoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if (currentLayoutAttributes.indexPath.section != prevLayoutAttributes.indexPath.section) {
            continue;
        }
        NSInteger maximumSpacing = self.minimumInteritemSpacing;
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}
@end

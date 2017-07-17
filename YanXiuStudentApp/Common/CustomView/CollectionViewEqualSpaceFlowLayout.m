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
    if (answer.count > 0) {
        UICollectionViewLayoutAttributes *firstLayoutAttributes = answer[0];
        if (firstLayoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            CGRect frame = firstLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            firstLayoutAttributes.frame = frame;
        }
    }
    
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
        
        if(currentLayoutAttributes.frame.origin.y == prevLayoutAttributes.frame.origin.y) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }else {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            currentLayoutAttributes.frame = frame;
        }
    }
    return answer;
}
@end

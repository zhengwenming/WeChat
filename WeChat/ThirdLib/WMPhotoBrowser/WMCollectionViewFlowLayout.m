//
//  WMCollectionViewFlowLayout.m
//  WMPhotoBrowser
//
//  Created by zhengwenming on 2018/6/11.
//  Copyright © 2018年 zhengwenming. All rights reserved.
//

#import "WMCollectionViewFlowLayout.h"

@implementation WMCollectionViewFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGSize size = self.collectionView.bounds.size;
    self.itemSize = CGSizeMake(size.width, size.height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 10;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttsArray = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0;
    __block CGFloat min = CGFLOAT_MAX;
    __block NSUInteger minIdx;
    [layoutAttsArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        if (ABS(centerX-obj.center.x) < min) {
            min = ABS(centerX-obj.center.x);
            minIdx = index;
        }
    }];
    [layoutAttsArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        if (minIdx - 1 == index) {
            obj.center = CGPointMake(obj.center.x-self.imgaeGap, obj.center.y);
        }
        if (minIdx + 1 == index) {
            obj.center = CGPointMake(obj.center.x+self.imgaeGap, obj.center.y);
        }
    }];
    return layoutAttsArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
@end

//
//  HorizontalCollectionViewLayout.m
//  MaxSocialShare
//
//  Created by Sun Jin on 4/5/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSHorizontalPageCollectionViewLayout.h"

@implementation MLSHorizontalPageCollectionViewLayout {
    NSInteger _cellCount;
    CGSize _boundsSize;
}

- (void)prepareLayout {
    // Get the number of cells and the bounds size
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _boundsSize = self.collectionView.bounds.size;
}

- (CGSize)collectionViewContentSize {
    // We should return the content size. Lets do some math:
    
    CGSize size = [super collectionViewContentSize];
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        NSInteger numberOfPages = (NSInteger)ceilf(size.width / _boundsSize.width);
        size.width = numberOfPages * _boundsSize.width;
        self.collectionView.pagingEnabled = YES;
    }
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // This method requires to return the attributes of those cells that intsersect with the given rect.
    // In this implementation we just return all the attributes.
    // In a better implementation we could compute only those attributes that intersect with the given rect.
    
    CGRect bounds = self.collectionView.bounds;
    CGSize itemSize = self.itemSize;
    
    // Get some info:
    NSInteger verticalItemsCount = (NSInteger)floorf((bounds.size.height - self.sectionInset.top - self.sectionInset.bottom + self.minimumLineSpacing) / (itemSize.height + self.minimumLineSpacing));
    
    NSInteger horizontalItemsCount = (NSInteger)floorf((bounds.size.width - self.sectionInset.left - self.sectionInset.right + self.minimumInteritemSpacing) / (itemSize.width + self.minimumInteritemSpacing));
    
    CGFloat actualLineSpacing = verticalItemsCount>1 ? (bounds.size.height - self.sectionInset.top - self.sectionInset.bottom - itemSize.height * verticalItemsCount) / (verticalItemsCount -1) : self.minimumLineSpacing;
    CGFloat actualInteritemSpacing = horizontalItemsCount >1 ? (bounds.size.width - self.sectionInset.left - self.sectionInset.right - itemSize.width * horizontalItemsCount) / (horizontalItemsCount -1) : self.minimumInteritemSpacing;
    
    NSInteger itemsPerPage = verticalItemsCount * horizontalItemsCount;
    
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:_cellCount];
    
    for (NSUInteger i=0; i<_cellCount; ++i) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        NSInteger row = indexPath.row;
        NSInteger columnPosition = row%horizontalItemsCount;
        NSInteger rowPosition = (row/horizontalItemsCount)%verticalItemsCount;
        NSInteger itemPage = floorf(row/itemsPerPage);
        
        // Creating an empty attribute
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame = CGRectZero;
        
        // And finally, we assign the positions of the cells
        frame.origin.x = itemPage * bounds.size.width + self.sectionInset.left + columnPosition * (itemSize.width + actualInteritemSpacing);
        frame.origin.y = self.sectionInset.top + rowPosition * (itemSize.height + actualLineSpacing);
        frame.size = self.itemSize;
        
        attr.frame = frame;
        
        [allAttributes addObject:attr];
    }
    
    return allAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // We should do some math here, but we are lazy.
    return YES;
}

#pragma mark Properties

- (void)setItemSize:(CGSize)itemSize {
    [super setItemSize:itemSize];
    [self invalidateLayout];
}

@end

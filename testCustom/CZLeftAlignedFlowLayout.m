//
//  CZLeftAlignedFlowLayout.m
//  collectionViewCus
//
//  Created by ChenZuo on 2017/3/21.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

#import "CZLeftAlignedFlowLayout.h"
#define SWIDTH [UIScreen mainScreen].bounds.size.width

@interface CZLeftAlignedFlowLayout ()
@property (retain, nonatomic) NSMutableArray *arrForItemAtrributes;
@property (assign, nonatomic) CGFloat widthSum;
@property (assign, nonatomic) CGFloat heightSum;
@property (assign, nonatomic) CGFloat contentHeight;

@end

@implementation CZLeftAlignedFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    _arrForItemAtrributes = [NSMutableArray array];
    _contentHeight = 0;
    NSInteger sectionNum = [self.collectionView numberOfSections];
    
    for (int i = 0; i < sectionNum; i++ ) {
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < itemNum; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [self settFrame:indexPath];
        }
    }
}

- (void)settFrame:(NSIndexPath *)indexPath{
    
    //从这可以获取size
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    CGFloat sizeWidth = currentItemAttributes.size.width;
    CGFloat sizeHeight = currentItemAttributes.size.height;
    
    //获取从delegate 获取信息
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
    CGFloat mininumItemSpace = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section]; //cell间隔
    CGFloat mininumLineSpace = [self evaluatedMinimumLineSpacingForSectionAtIndex:indexPath.section];//行间隔
    CGSize headViewSize = [self evaluatedHeaderSizeForSectionAtIndex:indexPath.section];
    
    BOOL isFirstItemInSection = indexPath.row == 0;
    BOOL isLastItemInSection = (indexPath.row + 1) == [self.collectionView numberOfItemsInSection:indexPath.section];
    BOOL hasHeaderView = headViewSize.height != 0 && headViewSize.width != 0;
    
    CGFloat estimatedWidth;
    
    if (isFirstItemInSection) {
        self.widthSum = sectionInset.left;//之前的
        if (hasHeaderView) {
            [self updateHeaderViewAttributesAtIndex:indexPath.section];
        }
        if (indexPath.section == 0) {
            self.heightSum = (sectionInset.top + headViewSize.height);
        }else{
            self.heightSum += (mininumLineSpace + sizeHeight + headViewSize.height + sectionInset.top);
        }
        currentItemAttributes.frame = CGRectMake(self.widthSum, self.heightSum, sizeWidth, sizeHeight);
        
        estimatedWidth = self.widthSum + mininumItemSpace + sizeWidth;
        self.widthSum = estimatedWidth;
        [self.arrForItemAtrributes addObject:currentItemAttributes];
        
        self.contentHeight = self.heightSum + sizeHeight + sectionInset.bottom;
        if (isLastItemInSection) {
            [self updateFooterViewAttributesAtInIndex:indexPath.section];
        }
    }else{
        estimatedWidth = self.widthSum + mininumItemSpace + sizeWidth;
        if (estimatedWidth > SWIDTH) {
            //换行
            self.heightSum += (self.minimumLineSpacing + sizeHeight);
            self.widthSum = sectionInset.left + self.space;
            //（不是第一行 + 加上space）
            currentItemAttributes.frame = CGRectMake(self.widthSum, self.heightSum, sizeWidth, sizeHeight);
            self.widthSum += (sizeWidth + mininumItemSpace);
            [self.arrForItemAtrributes addObject:currentItemAttributes];
        }else{
            
            currentItemAttributes.frame = CGRectMake(self.widthSum, self.heightSum, sizeWidth, sizeHeight);
            [self.arrForItemAtrributes addObject:currentItemAttributes];
            self.widthSum = estimatedWidth;
        }
        self.contentHeight = self.heightSum + sizeHeight + sectionInset.bottom;
        if (isLastItemInSection) {
            [self updateFooterViewAttributesAtInIndex:indexPath.section];
        }
    }
}

- (void)updateHeaderViewAttributesAtIndex:(NSInteger)section{
    UICollectionViewLayoutAttributes * header = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    CGRect frame = header.frame;
    frame.origin.y = self.contentHeight;
    header.frame = frame;
    [self.arrForItemAtrributes addObject:header];
}

- (void)updateFooterViewAttributesAtInIndex:(NSInteger)section{
    CGSize footerViewSize = [self evaluatedFooterSizeForSectionAtIndex:section];
    BOOL hasFooterView = footerViewSize.height != 0 && footerViewSize.width != 0;
    
    if (hasFooterView) {
        UICollectionViewLayoutAttributes * footer = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGRect frame = footer.frame;
        frame.origin.y = self.contentHeight;
        footer.frame = frame;
        [self.arrForItemAtrributes addObject:footer];
        self.contentHeight += footerViewSize.height;
        self.heightSum += footerViewSize.height;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.arrForItemAtrributes;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    contentSize.height = self.contentHeight;
    return contentSize;
}

- (CGSize)evaluatedHeaderSizeForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        id<CZLeftAlignedFlowLayoutDelegate> delegate = (id<CZLeftAlignedFlowLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:sectionIndex];
    } else {
        return CGSizeZero;
    }
}

- (CGSize)evaluatedFooterSizeForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        id<CZLeftAlignedFlowLayoutDelegate> delegate = (id<CZLeftAlignedFlowLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:sectionIndex];
    } else {
        return CGSizeZero;
    }
}

- (CGFloat)evaluatedMinimumLineSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        id<CZLeftAlignedFlowLayoutDelegate> delegate = (id<CZLeftAlignedFlowLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumLineSpacing;
    }
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<CZLeftAlignedFlowLayoutDelegate> delegate = (id<CZLeftAlignedFlowLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<CZLeftAlignedFlowLayoutDelegate> delegate = (id<CZLeftAlignedFlowLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}

- (NSInteger)space{
    if (!_space) {
        _space = 0;
    }
    return _space;
}
@end

//
//  CZLeftAlignedFlowLayout.h
//  collectionViewCus
//
//  Created by ChenZuo on 2017/3/21.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZLeftAlignedFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic)NSInteger space;

@end

@protocol CZLeftAlignedFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@end

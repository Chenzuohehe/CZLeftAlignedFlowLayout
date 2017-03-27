//
//  ViewController.m
//  testCustom
//
//  Created by ChenZuo on 2017/3/21.
//  Copyright © 2017年 ChenZuo. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CZLeftAlignedFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) NSMutableArray *hotTagArr;

@end

@implementation ViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotTagArr = [[NSMutableArray alloc] initWithArray:@[@"颜色" ,@"黑白", @"白", @"黑白灰", @"红棕", @"红", @"橙黄", @"黄绿", @"荧光绿", @"青", @"孔雀蓝", @"紫", @"其他"]];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    CZLeftAlignedFlowLayout * layout = [[CZLeftAlignedFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.space = 44;
    
    self.mainCollectionView.collectionViewLayout = layout;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotTagArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor grayColor];
    }
    cell.textLabel.text = self.hotTagArr[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = self.hotTagArr[indexPath.item];
    CGRect itemFrame = [content boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    
    CGFloat width = itemFrame.size.width + 10;
    return CGSizeMake(width, 30);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
}


- (CGFloat)widthForItemIndexPath:(NSIndexPath *)indexPath AndCollectioinView:(UICollectionView *)collectionView{
    
    NSString *content = self.hotTagArr[indexPath.item];
    CGRect itemFrame = [content boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    
    CGFloat width = itemFrame.size.width + 10;
    return width;
    
    return 10;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == 0 || indexPath.section == 2) {
            UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
            footerview.backgroundColor = [UIColor grayColor];
            for (UIView * view in footerview.subviews) {
                [view removeFromSuperview];
            }
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"Footer" forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor blackColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];            btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 60, 40, 120, 35);
            [footerview addSubview:btn];
            reusableView = footerview;
        }
    }else if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        for (UIView * view in headerview.subviews) {
            [view removeFromSuperview];
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"header";
        [headerview addSubview:label];
        reusableView = headerview;
    }
    return reusableView;
}

@end

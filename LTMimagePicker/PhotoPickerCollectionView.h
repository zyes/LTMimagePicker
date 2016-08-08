//
//  PhotoPickerCollectionView.h
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAsset.h"
#import "PhotoPickerCell.h"
@class PhotoPickerCollectionView;
@protocol PhotoPickerCollectionViewDelegate<NSObject>
// 选择相片就会调用
- (void) pickerCollectionViewDidSelected:(PhotoPickerCollectionView *) pickerCollectionView deleteAsset:(PhotoAsset *)deleteAssets;
//点击cell会调用
- (void) pickerCollectionCellTouchedIndexPath:(NSIndexPath *)indexPath;
@end

@interface PhotoPickerCollectionView : UICollectionView
@property(nonatomic,strong) NSArray *dataArr;
@property(nonatomic ,strong) NSMutableArray *selectArr;
@property(nonatomic,weak)id <PhotoPickerCollectionViewDelegate> collectdelegate;
@end

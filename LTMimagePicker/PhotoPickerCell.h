//
//  PhotoPickerCell.h
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerCell : UICollectionViewCell
+(instancetype)cellWithCollectionview:(UICollectionView *)collection cellForItemAtindex:(NSIndexPath *)index;
@property(nonatomic,strong) UIImage *cellImage;
@end

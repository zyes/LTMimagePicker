//
//  PhotoPickerCell.m
//  LTMimagePicker
//
//  Created by 张雨 on 16/7/20.
//  Copyright © 2016年 张雨. All rights reserved.
//

#import "PhotoPickerCell.h"
@implementation PhotoPickerCell
+(instancetype)cellWithCollectionview:(UICollectionView *)collection cellForItemAtindex:(NSIndexPath *)index{
    PhotoPickerCell *cell=[collection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:index];
    return cell;
}
@end
